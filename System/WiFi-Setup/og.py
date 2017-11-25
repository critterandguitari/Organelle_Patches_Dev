import liblo
import time 


enc_turn = 0
enc_but = 0
enc_turn_flag = False
enc_but_flag = False


def start_app ():
    liblo.send(osc_target, '/enableauxsub', 1)

def end_app ():
    liblo.send(osc_target, '/gohome', 1)
    exit()

def invert_line(num) :
    liblo.send(osc_target, '/oled/gInvertArea', 1, 0, num*11, 127, 11)

def println(num, s) :
    liblo.send(osc_target, '/oled/gPrintln', 1, 2, int(num * 11), 8, 1, s)

def clear_screen() :
    liblo.send(osc_target, '/oled/gClear', 1, 1)

def flip() :
    liblo.send(osc_target, '/oled/gFlip', 1)

osc_target = liblo.Address(4001)

try:
    server = liblo.Server(4002)
except liblo.ServerError, err:
    print str(err)
    sys.exit()

def enc_turn(path, args) :
    global enc_turn_flag, enc_turn
    enc_turn_flag = True
    enc_turn = args[0]

def enc_press(path, args) :
    global enc_but_flag, enc_but
    enc_but_flag = True
    enc_but = args[0]

server.add_method("/encoder/turn", 'i', enc_turn)
server.add_method("/encoder/button", 'i', enc_press)

def enc_input():
    global server, enc_turn_flag, enc_but_flag
    enc_turn_flag = False
    enc_but_flag = False
    while True :
        server.recv(10)
        if (enc_turn_flag or enc_but_flag) : break

def wait_for_turn():
    while True :
        enc_input()
        if (enc_turn_flag): break
    return enc_turn

def wait_for_press():
    while True :
        enc_input()
        if (enc_but_flag and (enc_but == 1)): break
    return enc_but

def wait_for_release():
    while True :
        enc_input()
        if (enc_but_flag and (enc_but == 0)): break
    return enc_but





