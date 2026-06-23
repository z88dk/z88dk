section code
start_code:
    defw $
    defw 1+2*3
    defw start_code
    defw start_code+2
    defw 2+start_code
    defw 2+start_code+2
    defw end_code-start_code
    defw start_data-end_code
    defw end_data-start_data
end_code:

section data
start_data:
    defw $
    defw 1+2*3
end_data:
