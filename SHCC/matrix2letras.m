function [letras]=matrix2letras(fIr,fIc)
letras=[];
matrix=[];

switch fIr
case 1
    switch fIc
        case 7
            letras=[letras 'A'];
        case 8
            letras=[letras 'B'];
        case 9
            letras=[letras 'C'];
        case 10
            letras=[letras 'D'];
        case 11
            letras=[letras 'E'];         
        case 12
            letras=[letras 'F'];
    end
case 2
    switch fIc
        case 7
            letras=[letras 'G'];
        case 8
            letras=[letras 'H'];
        case 9
            letras=[letras 'I'];
        case 10
            letras=[letras 'J'];
        case 11
            letras=[letras 'K'];         
        case 12
            letras=[letras 'L'];
    end
case 3
    switch fIc
        case 7
            letras=[letras 'M'];
        case 8
            letras=[letras 'N'];
        case 9
            letras=[letras 'O'];
        case 10
            letras=[letras 'P'];
        case 11
            letras=[letras 'Q'];         
        case 12
            letras=[letras 'R'];
    end
case 4
    switch fIc
        case 7
            letras=[letras 'S'];
        case 8
            letras=[letras 'T'];
        case 9
            letras=[letras 'U'];
        case 10
            letras=[letras 'V'];
        case 11
            letras=[letras 'W'];         
        case 12
            letras=[letras 'X'];
    end
case 5
    switch fIc
        case 7
            letras=[letras 'Y'];
        case 8
            letras=[letras 'Z'];
        case 9
            letras=[letras '1'];
        case 10
            letras=[letras '2'];
        case 11
            letras=[letras '3'];         
        case 12
            letras=[letras '4'];
end
case 6
    switch fIc
        case 7
            letras=[letras '5'];
        case 8
            letras=[letras '6'];
        case 9
            letras=[letras '7'];
        case 10
            letras=[letras '8'];
        case 11
            letras=[letras '9'];         
        case 12
            letras=[letras '_'];
    end
end

