; =====================================================================
; netClassify.il
; Purpose : Classify nets in the current schematic view into
;           Category A (hierarchy-crossing), B (high fan-out),
;           C (point-to-point local net), and dump a CSV for review.
; Usage   : load("netClassify.il")
;           netClassify_run()   ; uses hiGetCurrentWindow's cellview
; Output  : ~/netClassify_report.csv
; =====================================================================

; ---------------------------------------------------------------------
; Helper: return list of (instName pinName termName) for a given net
; ---------------------------------------------------------------------
procedure( netClassify_getTerminals(net)
    let( (termList result)
        result = nil
        termList = net~>terminals
        foreach( term termList
            let( (inst pinName)
                ; term~>instTerms gives connected instTerm(s) on this terminal
                foreach( it term~>instTerms
                    inst = it~>instName
                    pinName = it~>name
                    result = cons( list(inst pinName) result )
                ) ; foreach instTerm
            ) ; let
        ) ; foreach term
        result
    ) ; let
) ; procedure

; ---------------------------------------------------------------------
; Helper: does this net terminate on a hierarchy pin (i.e. touches a
; cellview boundary / higher-level net) rather than only leaf instances?
; A net is "hierarchy-crossing" if it has a terminal whose net object
; is also connected to the schematic's own I/O pins (net~>pins non-nil)
; ---------------------------------------------------------------------
procedure( netClassify_isHierCrossing(net)
    net~>pins != nil  ; non-nil means net touches a top-level I/O pin/symbol pin
) ; procedure

; ---------------------------------------------------------------------
; Main routine
; ---------------------------------------------------------------------
procedure( netClassify_run( @optional (outFile "~/netClassify_report.csv") )
    let( (cv win nets port fanout category instPinPairs pairStr)
        win = hiGetCurrentWindow()
        unless( win
            error("No open schematic window. Open the schematic first.")
        )
        cv = win~>cellView
        nets = cv~>nets

        port = outfile( outFile "w" )
        unless( port
            error("Cannot open output file %s" outFile)
        )

        fprintf( port "NetName,FanOut,Category,ConnectedInstPins\n" )

        foreach( net nets
            instPinPairs = netClassify_getTerminals(net)
            fanout = length(instPinPairs)

            ; --- classification logic ---
            category = "C_local"
            if( netClassify_isHierCrossing(net) then
                category = "A_hierCross"
            else if( fanout >= 3 then
                category = "B_highFanout"
            ) ) ; else falls through to C_local

            ; build a readable "inst.pin;inst.pin;..." string
            pairStr = ""
            foreach( p instPinPairs
                pairStr = strcat( pairStr car(p) "." cadr(p) ";" )
            )

            fprintf( port "%s,%d,%s,%s\n"
                net~>name
                fanout
                category
                pairStr
            )
        ) ; foreach net

        close(port)
        printf("netClassify: wrote %d nets to %s\n" length(nets) outFile)
        t
    ) ; let
) ; procedure