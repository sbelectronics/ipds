; Ports for iPDS

; iPDS uses ATTACH syscall when attaching multimodules

DOATTCH EQU     1

; CSG Multimodule

CSGPORT	EQU	073H
CSMPORT	EQU	074H    ; Mute for CSG board

; PSG Multimodule

PSGREG	EQU	075H
PSGVAL	EQU	076H
PSMPORT	EQU	077H    ; Mute for PSG board

; TIL311 multimodule

TILL    EQU     070H
TILM    EQU     071H
TILR    EQU     072H
TILB    EQU     073H    ; blanking port
TILI    EQU     070H    ; input port

; RTC multimodule

RTCDAT  EQU     070H
RTCADR  EQU     071H
RTCCTL  EQU     072H
RTC82C  EQU     073H

; Serial multimodule

SERBAS  EQU     070H
