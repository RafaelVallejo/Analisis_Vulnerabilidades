#!/usr/bin/python
# -*- coding: utf-8 -*-
# Vallejo Fernández Rafael Alejandro
# cadena = 'rafael.vallejo.*+0123456789cg'
# cadena = 'rafae-l.val-lejo.-*+456-7r9Aa'
# cadena = 'rafae-l.val-Aalej-o.*+4-567r9'
cadena = 'rafae-l.val-lejo.-*+456-7r95m'
suma = 0

for c in cadena:
    suma += ord(c)

print 'Suma de %i caracteres: %i ' % (len(cadena),suma)
print 'Diferencia de cantidad de caracteres %i - %i = %i' % (29,len(cadena),29-len(cadena))
print 'Diferencia de suma %i - %i = %i' % (2272,suma,2272-suma)
