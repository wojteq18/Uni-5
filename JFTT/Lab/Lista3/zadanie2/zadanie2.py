import sys
import ply.lex as lex
import ply.yacc as yacc

P = 1234577

# --- LEKSER (Analiza leksykalna) ---

tokens = (
    'NUM',
    'PLUS', 'MINUS', 'MUL', 'DIV', 'POW',
    'LPAREN', 'RPAREN',
)

precedence = (
    ('left', 'PLUS', 'MINUS'),
    ('left', 'MUL', 'DIV'),
    ('left', 'POW'),
    ('right', 'UMINUS'),
)

class LexerContext:
    def __init__(self):
        self.expect_operand = True

context = LexerContext()

t_PLUS    = r'\+'
t_MUL     = r'\*'
t_DIV     = r'\/'
t_POW     = r'\^'
t_LPAREN  = r'\('
t_RPAREN  = r'\)'
t_ignore  = ' \t'

def t_COMMENT(t):
    r'\#.*'
    pass

def t_BACKSLASH_NEWLINE(t):
    r'\\\n'
    pass

def t_newline(t):
    r'\n+'
    t.lexer.lineno += len(t.value)
    context.expect_operand = True
    return None

def t_OP_PLUS(t):
    r'\+'
    context.expect_operand = True
    t.type = 'PLUS'
    return t

def t_OP_MUL(t):
    r'\*'
    context.expect_operand = True
    t.type = 'MUL'
    return t

def t_OP_DIV(t):
    r'\/'
    context.expect_operand = True
    t.type = 'DIV'
    return t

def t_OP_POW(t):
    r'\^'
    context.expect_operand = True
    t.type = 'POW'
    return t

def t_OP_LPAREN(t):
    r'\('
    context.expect_operand = True
    t.type = 'LPAREN'
    return t

def t_OP_RPAREN(t):
    r'\)'
    context.expect_operand = False
    t.type = 'RPAREN'
    return t

def t_NUM_OR_MINUS(t):
    r'-?\d+|-'
    
    if t.value == '-':
        t.type = 'MINUS'
        context.expect_operand = True
        return t

    is_negative = t.value.startswith('-')
    
    if is_negative:
        if context.expect_operand:
            val = int(t.value)
            val = val % P
            if val < 0: val += P
            t.value = val
            t.type = 'NUM'
            context.expect_operand = False
            return t
        else:
            full_text = t.value
            
            t.type = 'MINUS'
            t.value = '-'
            context.expect_operand = True
            
            t.lexer.lexpos -= (len(full_text) - 1)
            return t
    else:
        t.value = int(t.value) % P
        t.type = 'NUM'
        context.expect_operand = False
        return t

def t_error(t):
    print(f"Błąd leksykalny: Nieznany znak '{t.value[0]}'", flush=True)
    t.lexer.skip(1)

lexer = lex.lex()

# --- PARSER (Analiza składniowa) ---

def gf_add(a, b): return (a + b) % P
def gf_sub(a, b): return (a - b) % P
def gf_mul(a, b): return (a * b) % P
def gf_pow(base, exp): return pow(base, exp, P)

def gf_div(a, b):
    if b == 0:
        raise ZeroDivisionError("Dzielenie przez zero")
    inv = pow(b, P-2, P)
    return (a * inv) % P

def p_expr_binop(p):
    '''expr : expr PLUS expr
            | expr MINUS expr
            | expr MUL expr
            | expr DIV expr
            | expr POW expr'''
    if p[2] == '+':
        p[0] = gf_add(p[1], p[3])
        print("+", end=' ', flush=True) 
    elif p[2] == '-':
        p[0] = gf_sub(p[1], p[3])
        print("-", end=' ', flush=True)
    elif p[2] == '*':
        p[0] = gf_mul(p[1], p[3])
        print("*", end=' ', flush=True)
    elif p[2] == '/':
        try:
            p[0] = gf_div(p[1], p[3])
            print("/", end=' ', flush=True)
        except ZeroDivisionError:
            print("\nBłąd: Dzielenie przez zero!", flush=True)
            raise SyntaxError
    elif p[2] == '^':
        p[0] = gf_pow(p[1], p[3])
        print("^", end=' ', flush=True)

def p_expr_uminus(p):
    'expr : MINUS expr %prec UMINUS'
    p[0] = gf_sub(0, p[2])
    print("NEG", end=' ', flush=True)

def p_expr_group(p):
    'expr : LPAREN expr RPAREN'
    p[0] = p[2]

def p_expr_number(p):
    'expr : NUM'
    p[0] = p[1]
    print(p[1], end=' ', flush=True)

def p_error(p):
    if p:
        print(f"\nBłąd składni przy symbolu '{p.value}'", flush=True)
    else:
        print("\nBłąd składni na końcu wejścia", flush=True)

parser = yacc.yacc()


def process_line(line):
    context.expect_operand = True
    if not line.strip(): return
    try:
        result = parser.parse(line, lexer=lexer)
        if result is not None:
            print(f"\nWynik: {result}", flush=True)
    except SyntaxError:
        pass
    except Exception as e:
        print(f"\nBłąd wykonania: {e}", flush=True)

def main():
    interactive = sys.stdin.isatty()
    
    if interactive:
        print("GF> ", end='', flush=True)

    buffer = ""
    for line in sys.stdin:
        stripped = line.rstrip('\n')
        if stripped.endswith('\\'):
            buffer += stripped[:-1]
            if interactive:
                print("... ", end='', flush=True)
            continue
        else:
            buffer += stripped
        
        process_line(buffer)
        buffer = ""
        
        if interactive:
            print("GF> ", end='', flush=True)

if __name__ == "__main__":
    main()