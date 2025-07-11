; Final (final.asm)
; Program Description: Blackjack Game, Try to get as close to 21 as possible without going over, and beat dealer's hand.
; Author: Arian Rasoli
; Creation Date: 05/04/2025

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

; Include the Irvine32 library to ensure that the code runs correctly

INCLUDE C:\Irvine\Irvine32.inc 
INCLUDELIB C:\Irvine\Irvine32.lib 

.data

welcome byte "Welcome to Blackjack!",0
instructions byte "Instructions: Try to get as close to 21 as possible without going over, and beat dealer's hand!",0
hearts byte " Hearts",0
diamonds byte " Diamonds",0
clubs byte " Clubs",0
spades byte " Spades",0

total_prompt byte "Your total is: ",0
ace byte "Ace",0
jack byte "Jack",0
queen_king byte "Queen/King",0
hit_or_stand byte "Would you like to ('H'/'h'. Hit) or ('S'/'s'. Stand): ",0
error_prompt byte "Invalid input, please select ('H'. Hit) or ('S'. Stand): ",0
try_again_prompt byte "Try again? (Y/y for yes, N/n for no): ",0
try_again_prompt_error byte "Invalid input, please select (Y/y for yes) or (N/n for no)",0
win_prompt byte "You win!",0
lose_prompt byte "You lose!",0
tie_prompt byte "It's a tie!",0

your_hand byte "Your hand: ",0
dealer_hand byte "Dealer hand total: ",0
card1 dword ?
card2 dword ?
score21 byte "Your hand: 21",0

deck dword ?
dealer_deck dword ?
hit_input byte ?
input byte ?
final_dealer_prompt byte "Dealer's final hand: ",0
dealer_bust_prompt byte "Dealer bust! You win!",0
user_bust_prompt byte "Bust! You went over 21.",0

.code
main proc
    
L0:
    mov edx, OFFSET welcome                 ; Display welcome message
    call WriteString                        ; Call WriteString to print the message
    call Crlf                               ; Print a new line

    mov edx, OFFSET instructions            ; Display instructions
    call WriteString                        ; Call WriteString to print the instructions
    call Crlf                               ; Print a new line
    
    call Randomize                          ; Randomize the random number generator

    mov edx, OFFSET your_hand               ; Display your hand message
    call WriteString                        ; Call WriteString to print the message
    call Crlf                               ; Print a new line

first_card:
    mov eax, 13                             ; Set the upper limit for the random number
    call RandomRange                        ; Generate a random number between 1 and 13
    inc eax                                 ; Increment the random number by 1
    mov card1, eax                          ; Store the random number in card1

    cmp eax,1                               ; Check if the card is a special card
    je special1                             ; Jump to special1 if it is a special card

    cmp eax,11                              ; Check if the card is a special card
    je special1                             ; Jump to special1 if it is a special card

    cmp eax,12                              ; Check if the card is a special card
    je special1                             ; Jump to special1 if it is a special card

    cmp eax,13                              ; Check if the card is a special card
    je special1                             ; Jump to special1 if it is a special card

    ; Include Suit if not special
    mov eax, card1                          ; Load card1 into eax
    call WriteInt                           ; Display the card value

    mov eax,4                               ; Set the upper limit for the random number
    call RandomRange                        ; Generate a random number between 0 and 3
    mov ecx, eax                            ; Store the random number in ecx                    

    cmp ecx,0                               ; Check if the suit is hearts
    je heart_pull1                          ; Jump to heart_pull1 if it is hearts

    cmp ecx,1                               ; Check if the suit is diamonds
    je diamond_pull1                        ; Jump to diamond_pull1 if it is diamonds

    cmp ecx,2                               ; Check if the suit is clubs
    je club_pull1                           ; Jump to club_pull1 if it is clubs

    cmp ecx,3                               ; Check if the suit is spades
    je spade_pull1                          ; Jump to spade_pull1 if it is spades

    jmp second_card                         ; Jump to second_card if no suit is found

heart_pull1:
    mov edx, OFFSET hearts                  ; Load hearts string into edx
    call WriteString                        ; Display the hearts string
    call Crlf                               ; Print a new line

    jmp second_card                         ; Jump to second_card

diamond_pull1:
    mov edx, OFFSET diamonds                ; Load diamonds string into edx
    call WriteString                        ; Display the diamonds string
    call Crlf                               ; Print a new line

    jmp second_card                         ; Jump to second_card

club_pull1:
    mov edx, OFFSET clubs                   ; Load clubs string into edx
    call WriteString                        ; Display the clubs string
    call Crlf                               ; Print a new line
    jmp second_card                         ; Jump to second_card

spade_pull1:
    mov edx, OFFSET spades                  ; Load spades string into edx
    call WriteString                        ; Display the spades string
    call Crlf                               ; Print a new line
    jmp second_card                         ; Jump to second_card

special1:
    cmp eax,1                               ; Check if the card is an ace
    je ace1                                 ; Jump to ace1 if it is an ace

    cmp eax, 11                             ; Check if the card is a jack
    je ace1                                 ; Jump to ace1 if it is a jack
        
    cmp eax, 12                             ; Check if the card is a queen or king
    je jack1                                ; Jump to jack1 if it is a queen or king

    cmp eax,13                              ; Check if the card is a queen or king
    je queen_king1                          ; Jump to queen_king1 if it is a queen or king

ace1:
    mov edx, OFFSET ace                     ; Load ace string into edx
    call WriteString                        ; Display the ace string
    call Crlf                               ; Print a new line
        
    mov eax, 11                             ; Set the value of card1 to 11
    mov card1, eax                          ; Store the value in card1
    jmp second_card                         ; Jump to second_card

jack1:
    mov edx, OFFSET jack                    ; Load jack string into edx
    call WriteString                        ; Display the jack string
    call Crlf                               ; Print a new line

    mov eax,10                              ; Set the value of card1 to 10
    mov card1,eax                           ; Store the value in card1
    jmp second_card                         ; Jump to second_card
        
queen_king1:
    mov edx, OFFSET queen_king              ; Load queen_king string into edx
    call WriteString                        ; Display the queen_king string
    call Crlf                               ; Print a new line

    mov card1, 10                           ; Set the value of card1 to 10
    jmp second_card                         ; Jump to second_card

second_card:
    mov eax, 13                             ; Set the upper limit for the random number
    call RandomRange                        ; Generate a random number between 1 and 13
    inc eax                                 ; Increment the random number by 1
    mov card2, eax                          ; Store the random number in card2

    mov eax, card2                          ; Load card2 into eax

    cmp eax,1                               ; Check if the card is a special card
    je special2                             ; Jump to special2 if it is a special card

    cmp eax,11                              ; Check if the card is a special card
    je special2                             ; Jump to special2 if it is a special card

    cmp eax,12                              ; Check if the card is a special card
    je special2                             ; Jump to special2 if it is a special card
        
    cmp eax,13                              ; Check if the card is a special card
    je special2                             ; Jump to special2 if it is a special card
        
    mov eax, card2                          ; Load card2 into eax
    call WriteInt                           ; Display the card value

    mov eax,4                               ; Set the upper limit for the random number
    call RandomRange                        ; Generate a random number between 0 and 3
    mov ecx,eax                             ; Store the random number in ecx

    cmp ecx,0                               ; Check if the suit is hearts
    je heart_pull2                          ; Jump to heart_pull2 if it is hearts

    cmp ecx,1                               ; Check if the suit is diamonds
    je diamond_pull2                        ; Jump to diamond_pull2 if it is diamonds

    cmp ecx,2                               ; Check if the suit is clubs
    je club_pull2                           ; Jump to club_pull2 if it is clubs

    cmp ecx,3                               ; Check if the suit is spades
    je spade_pull2                          ; Jump to spade_pull2 if it is spades

    jmp total                               ; Jump to total if no suit is found
    
heart_pull2:
    mov edx, OFFSET hearts                  ; Load hearts string into edx
    call WriteString                        ; Display the hearts string
    call Crlf                               ; Print a new line
    jmp total                               ; Jump to total

diamond_pull2:
    mov edx, OFFSET diamonds                ; Load diamonds string into edx
    call WriteString                        ; Display the diamonds string
    call Crlf                               ; Print a new line
    jmp total                               ; Jump to total

club_pull2:
    mov edx, OFFSET clubs                   ; Load clubs string into edx
    call WriteString                        ; Display the clubs string
    call Crlf                               ; Print a new line
    jmp total                               ; Jump to total

spade_pull2:
    mov edx, OFFSET spades                  ; Load spades string into edx
    call WriteString                        ; Display the spades string
    call Crlf                               ; Print a new line  
    jmp total                               ; Jump to total 

special2:                                   ; Check if the card is a special card
    cmp eax,1                               ; Check if the card is an ace
    je ace2                                 ; Jump to ace2 if it is an ace
    cmp eax, 11                             ; Check if the card is a jack
    je ace2                                 ; Jump to ace2 if it is a jack

    cmp eax, 12                             ; Check if the card is a queen or king
    je jack2                                ; Jump to jack2 if it is a queen or king

    cmp eax,13                              ; Check if the card is a queen or king
    je queen_king2                          ; Jump to queen_king2 if it is a queen or king

ace2:                                       
    mov edx, OFFSET ace                     ; Load ace string into edx
    call WriteString                        ; Display the ace string
    call Crlf                               ; Print a new line
            
    mov eax, 11                             ; Set the value of card2 to 11
    mov card2, eax                          ; Store the value in card2
    jmp total                               ; Jump back to total

jack2:   
    mov edx, OFFSET jack                    ; Move jack prompt into edx register
    call WriteString                        ; Print string
    call Crlf                               ; Print new line
            
    mov card2, 10                           ; Since Jack Card = 10, add it to total
    jmp total                               ; Jump to total

queen_king2: 
    mov edx, OFFSET queen_king              ; Move queen_king prompt into edx register
    call WriteString                        ; Print string
    call Crlf                               ; Print new line

    mov card2, 10                           ; Move card into card2 register
    jmp total                               ; Jump back to total 

total:
    mov edx, OFFSET total_prompt            ; Move total prompt into edx register
    call WriteString                        ; Print string

    mov ebx, card1                          ; Move card1 into ebx register
    mov ecx, card2                          ; Move card2 into ecx register
    add ebx,ecx                             ; Add both, store in ebx

    cmp ebx,22                              ; If ebx contains both aces
    je adjust_aces                          ; Jump to adjust

    mov deck,ebx                            ; Move ebx into deck register
    mov eax, deck                           ; Move deck into eax register to print 
    call WriteInt                           ; Print total value
    call Crlf                               ; Print new line

    jmp hit_stand                           ; Jump to user hit/stand

adjust_aces:
    mov eax,11                              ; Move 11 into eax register
    mov card1, eax                          ; Move eax into card1 register (card1=11)
    mov eax,1                               ; Move 1 into eax register
    mov card2,eax                           ; Move eax into card2 register (card2=1)

    mov ebx, card1                          ; Move card1 into ebx register
    mov ecx, card2                          ; Move card2 into ebx register

    add ebx,ecx                             ; Add ebx and ecx together to get 12
    mov deck,ebx                            ; Move ebx into deck

    mov eax,deck                            ; Move deck into eax register
    call WriteInt                           ; Write the total 
    call Crlf                               ; Print new line

    jmp hit_stand                           ; JUmp to user hit/stand

hit_stand:
    mov edx, OFFSET hit_or_stand            ; Move hit/stand prompt into edx 
    call WriteString                        ; Print string
    mov edx, OFFSET hit_input               ; Move input into edx register
    call ReadChar                           ; Read character from user
    call Crlf                               ; Print new line

    cmp al, 'H'                             ; If 'H'
    je hit                                  ; hit
    cmp al, 'h'                             ; If 'h'
    je hit                                  ; hit

    cmp al, 'S'                             ; If 'S'
    je stand                                ; Stand, dealer plays now.
    cmp al, 's'                             ; If 's'
    je stand                                ; Stand, dealer plays now.

    jmp error                               ; If none chosen, jump to error prompt.

error:
    call Crlf                               ; Print new line
    mov edx, OFFSET error_prompt            ; Move error prompt into edx 
    call WriteString                        ; Print string
    call Crlf                               ; Print new line
    jmp hit_stand                           ; Jump back to get valid input

hit:
    mov eax, 13                             ; Set upper limit for randomrange
    call RandomRange                        ; 0-13 random-range
    inc eax                                 ; Increment eax by 1
    mov esi, eax                            ; Move eax into esi register

    cmp esi,1                               ; Check if card is ace
    je special_hit                          ; Jump to special
    cmp esi,11                              ; If card is ace
    je special_hit                          ; Jump to special
    cmp esi,12                              ; If card is Jack
    je special_hit                          ; Jump to special
    cmp esi,13                              ; If card is queen/king
    je special_hit                          ; Jump to special hit.

    ; If not special
    mov ebx, deck                           ; Move deck into ebx
    add ebx, eax                            ; Add card value to deck

    cmp ebx,21                              ; If ebx
    jg bust                                 ; If ebx > 21 (bust)
    je player_wins                          ; If ebx = 21 (win)

    mov deck,ebx                            ; Move ebx register into total 
    call WriteInt                           ; Print total value

    mov ebx, eax                            ; Move eax value into ebx

    mov eax,4                               ; Face Card 0-3 range
    call RandomRange                        ; Call randomrange for value
    mov ecx, eax                            ; Move randomrange value into ecx

    cmp ecx,0                               ; If 0 
    je heart                                ; Jump to hearts

    cmp ecx,1                               ; If 1
    je diamond                              ; Jump to diamonds

    cmp ecx,2                               ; If 2
    je club                                 ; Jump to clubs

    cmp ecx,3                               ; If 3
    je spade                                ; Jump to spade

    jmp hit_stand                           ; Jump to hit_stand after card

heart:
    mov edx, OFFSET hearts                  ; Move hearts into edx
    call WriteString                        ; Print suit
    call Crlf                               ; Print new line
    jmp print_card_value                    ; Jump to print card value

diamond:
    mov edx, OFFSET diamonds                ; Move diamonds into edx
    call WriteString                        ; Print suit
    call Crlf                               ; Print new line
    jmp print_card_value                    ; Jump to print card value

club:
    mov edx, OFFSET clubs                   ; Move clubs into edx
    call WriteString                        ; Print suit
    call Crlf                               ; Print new line
    jmp print_card_value                    ; Jump to print card value

spade:
    mov edx, OFFSET spades                  ; Move spades into edx
    call WriteString                        ; Print suit
    call Crlf                               ; Print new line
    jmp print_card_value                    ; Jump to print card value

print_card_value:
    mov eax,ebx                             ; Move ebx to eax
    mov ebx, deck                           ; Move deck to ebx register

    mov edx, OFFSET total_prompt            ; Move total prompt into edx
    call WriteString                        ; Print prompt
    call Crlf                               ; Print new line
    mov eax, ebx                            ; Move ebx into eax to print
    call WriteInt                           ; Print total

    cmp eax,21                              ; If total is 21
    jg bust                                 ; Jump > 21 to bust 

    call Crlf                               ; Print new line

    mov deck,ebx                            ; Move total back into deck

    jmp hit_stand                           ; Jump back to hit_stand

special_hit:
    cmp eax,1                               ; If eax=1
    je ace_hit                              ; Ace

    cmp eax,11                              ; If eax=11
    je ace_hit                              ; Ace

    cmp eax,12                              ; If eax=12
    je jack_hit                             ; Jack

    cmp eax,13                              ; If eax=13
    je queen_king_hit                       ; Queen/King

ace_hit:
    mov edx, OFFSET ace                     ; Move ace prompt into edx
    call WriteString                        ; Print prompt
    call Crlf                               ; Print new line
        
    mov eax, deck                           ; Move deck into eax register
    add eax, 11                             ; Add total by 11

    cmp eax,21                              ; If eax>21
    jg one                                  ; Jump to one
        
    mov deck,eax                            ; Move total back to deck
    call WriteInt                           ; Print new total
    call Crlf                               ; Print new line
    jmp hit_stand                           ; Jump back to hit_stand

one:
    mov eax, deck                           ; Move deck into eax
    add eax, 1                              ; Add total by 1

    cmp eax,21                              ; If eax=21
    je player_wins                          ; Jump to win

    mov deck,eax                            ; Move total back into deck
    call WriteInt                           ; Print total
    call Crlf                               ; Print new line

    jmp hit_stand                           ; Jump back to hit_stand

jack_hit:
    mov edx, OFFSET jack                    ; Move jack prompt into edx
    call WriteString                        ; Print prompt
    call Crlf                               ; Print new line

    mov eax, deck                           ; Move deck into eax
    add eax, 10                             ; Add eax by 10

    cmp eax,21                              ; If eax>21
    jg bust                                 ; Jump to bust

    mov deck,eax                            ; Move new total into deck
    call WriteInt                           ; Print new total
    call Crlf                               ; Print new line

    jmp hit_stand                           ; Jump back to hit_stand

queen_king_hit:
    mov edx, OFFSET queen_king              ; Move queen_king prompt into edx
    call WriteString                        ; Print prompt
    call Crlf                               ; Print new line

    mov eax, deck                           ; Move deck into eax
    add eax, 10                             ; Add eax by 10

    cmp eax, 21                             ; If eax>21
    jg bust                                 ; Jump to bust

    mov deck, eax                           ; Move new total back into deck
    call WriteInt                           ; Print new total 
    call Crlf                               ; Print new line

    jmp hit_stand                           ; Jump to hit_stand


bust:
    mov edx, OFFSET user_bust_prompt        ; Move user_bust_prompt into edx
    call WriteString                        ; Print prompt

    jmp try_again                           ; Jump to try_again 
        
stand:
    mov edi, 0                              ; Set dealer hand to 0
    mov eax, edi                            ; Move dealer hand to eax 
    call Crlf                               ; Print new line

    ; Dealer's turn
    dealer_turn:
        
        cmp edi, 17                         ; If dealer hand >= 17
        jge dealer_done                     ; Jump to dealer_done

        ; Else
        mov eax, 13                         ; Set upper limit for random number      
        call RandomRange                    ; Call RandomRange for random value
        inc eax                             ; Increment value by 1
        add edi, eax                        ; Add random value to dealer hand

        cmp edi, 21                         ; If edi > 21
        jg dealer_bust                      ; Jump to Dealer bust

        jmp dealer_turn                     ; Jump back to dealer_turn if none apply

    dealer_done:
        
        mov edx, OFFSET final_dealer_prompt ; Move final dealer prompt into edx
        mov eax, edi                        ; Mov edi value into eax
        call WriteString                    ; Print propmt
        call WriteInt                       ; Print final dealer total 
        call Crlf                           ; Print new line

        ; Compare dealer deck and player deck
        cmp edi, deck                                              
        ja dealer_win                       ; If dealer > player, dealer wins                      
        jb player_wins                      ; If dealer < player, player wins
        je tie                              ; If dealer = player, tie

dealer_bust:
    
    mov edx, OFFSET dealer_hand             ; Move dealer_hand prompt into edx register
    call WriteString                        ; Print prompt
    mov eax, edi                            ; Move dealer total into eax
    call WriteInt                           ; Print dealer final total
    call Crlf                               ; Print new line

    mov edx, OFFSET dealer_bust_prompt      ; Move dealer_bust_propmt into edx
    call WriteString                        ; Print prompt
    call Crlf                               ; Print new line

    jmp try_again                           ; Jump to try_again 

dealer_win:
    mov edx, OFFSET lose_prompt             ; Move lose prompt into edx
    call WriteString                        ; Print prompt
    call Crlf                               ; Print new line
    jmp try_again                           ; Jump to try again

player_wins:

    mov edx, OFFSET your_hand               ; Move your hand prompt into edx
    call WriteString                        ; Print prompt
    mov eax, deck                           ; Move player deck into eax
    call WriteInt                           ; Print player total
    call Crlf                               ; Print new line

    mov edx, OFFSET win_prompt              ; Move win prompt into edx
    call WriteString                        ; Print prompt
    call Crlf                               ; Print new line
    jmp try_again                           ; Jump to try again

tie:
    call Crlf                               ; Print new line
    mov edx, OFFSET tie_prompt              ; Move tie prompt into edx
    call WriteString                        ; Print prompt
    call Crlf                               ; Print new line
    jmp try_again                           ; Jump to try_again
        
try_again:
    call Crlf                               ; Print new line
    mov edx, OFFSET try_again_prompt        ; Move try again prompt into edx
    call WriteString                        ; Print prompt
    mov edx, OFFSET input                   ; Move input into edx
    call ReadChar                           ; Read char input from user
    call Crlf                               ; Print new line

    cmp al, 'Y'                             ; If user = 'Y'
    je L0                                   ; Jump back to start (L0)
        
    cmp al, 'y'                             ; If user = 'y'
    je L0                                   ; Jump back to start (L0)

    cmp al, 'N'                             ; If user = 'N'
    je exit_program                         ; Jump to exit program 

    cmp al, 'n'                             ; If user = 'n'
    je exit_program                         ; Jump to exit program

    jmp try_again_error                     ; If none apply, jump to try_again_error

try_again_error:    
    call Crlf                               ; Print new line
    mov edx, OFFSET try_again_prompt_error  ; Move try_again_prompt_error into edx
    call WriteString                        ; Print prompt
    jmp try_again                           ; Jump back to try_again for valid input

; Exit Program
exit_program:
    invoke ExitProcess,0
main endp
end main