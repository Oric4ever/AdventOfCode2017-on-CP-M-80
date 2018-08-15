; assemble with zasm 


		org     $3F00
        dw      end-start
start
        push    hl
        push    hl
        ld      bc,1
        ld      de,0
        exx
        ld      bc,0
        ld      de,0
        exx
loop
        ld      hl,356
        add     hl,de
        ex      de,hl
        exx
        ld      hl,0
        adc     hl,de
        ex      de,hl
        exx
modulo
        ld      h,d
        ld      l,e
        or      a
        sbc     hl,bc
        exx
        ld      h,d
        ld      l,e
        sbc     hl,bc
        jr      c,mod_ok
        ex      de,hl
        exx
        ex      de,hl
        jr      modulo
mod_ok
        ld      a,e
        or      d
        exx
        or      e
        or      d
        jr      nz,not_zero
        exx
        pop     hl
        pop     hl
        push    bc
        exx
        push    bc
not_zero
        ld      hl,1
        add     hl,de
        ex      de,hl
        exx
        ld      hl,0
        adc     hl,de
        ex      de,hl
        exx
        ld      hl,1
        add     hl,bc
        ld      b,h
        ld      c,l
        exx
        ld      hl,0
        adc     hl,bc
        ld      b,h
        ld      c,l
        exx
        ld      hl,$F080
        or      a
        sbc     hl,bc
        exx
        ld      hl,$02FA
        sbc     hl,bc
        exx
        jr      nc,loop

        pop     bc
        pop     de
        pop     hl
        push    de
        push    bc
        push    hl
        ret
end

