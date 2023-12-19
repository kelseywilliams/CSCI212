from random import randint

root = [i*0 for i in range(45)]

n = 45
p = randint(1,45)

def split_deck(a, n, p):
    i = 0
    while i < p - 1:
        chunk = randint(1, n - p + i + 1)
        a[i] = chunk
        n = n - chunk
        i += 1
    a[i] = n

def move(a, p):
    total = 0
    i = 0
    while i < p:
        if a[i] != 0:
            total += 1
            a[i] -= 1
            if a[i] == 0:
                p = left_shift(a, p)
            else:
                i += 1
        else:
            p = left_shift(a, p)
    a[p] = total
    p += 1
    return p

def left_shift(a, p):
    i = 0
    while i < p:
        if a[i] == 0:
            for j in range(i + 1, p):
                a[j - 1] = a[j]
            a[p - 1] = 0
            p -= 1
        i += 1
    return p

def check_stable(a,p):
    if p != 9:
        return False
    else:
        i = 0
        while i < 8:
            if a[i] == a[i + 1] - 1 :
                i += 1
            else:
                return False
        return True

split_deck(root, n, p)
starting = [x for x in root]
counter = 0
while check_stable(root, p) != True:
    p = move(root, p)
    print(f"\n{counter}: {root}")
    counter += 1
