


class MainMenu :
    index = 0

    def init(self):
        print "mm init"

    def enc(self):
        print "enc"


menu = MainMenu()

active = menu


def cool() :
    global active
    active.enc()

cool()
