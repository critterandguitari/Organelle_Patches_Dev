import os
import imp

current_dir = os.path.dirname(os.path.abspath(__file__))
og = imp.load_source('og', current_dir + '/og.py')

def quit():
    og.end_app()

class Alert :
    msg = "HI!"
    def perform(self):
        og.clear_screen()
        og.println(3, self.msg)
        og.flip()
        og.wait_for_turn()
        #while True :
        #    og.enc_input()
        #    if (og.enc_turn_flag) : break

class Menu :
    items = None
    selection = 0
    back_flag = False
    def draw(self) :
        og.clear_screen()
        i = 0
        for item in self.items :
            og.println(i, item[0])
            i += 1
        og.invert_line(self.selection)
        og.flip()
   
    def back(self):
        self.back_flag = True
    
    def perform(self) :
        self.back_flag = False
        self.draw()
        while True :
            og.enc_input()
            if (og.enc_turn_flag) :
                i = og.enc_turn
                if i == 0 :
                    self.selection -= 1
                if i == 1 :
                    self.selection += 1
                if self.selection >= 4 :
                    self.selection = 4
                if self.selection <= 0 :
                    self.selection = 0
                self.draw()
                #liblo.send(osc_target, '/oled/gPrintln', 1, 64, 32, 24, 1, selection)
            if (og.enc_but_flag) :
                if (og.enc_but == 1) :
                    self.items[self.selection][1]()
                    print "returned"
                    if (self.back_flag) : break
                    else : self.draw()

hello = Alert()
hello.msg = "REAL COOL!!"
main_menu = Menu()
menu2 = Menu()
menu2.items = [
    ['Alert2', hello.perform],
    ['Back', menu2.back]
]
main_menu.items = [
    ['Alert', hello.perform],
    ['Menu 2', menu2.perform],
    ['Quit',  quit]
]


main_menu.selection = 1

og.start_app()
main_menu.draw()
og.flip()

main_menu.perform()



