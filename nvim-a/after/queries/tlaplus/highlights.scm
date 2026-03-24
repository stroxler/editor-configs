; extends
; TLA+ conceal rules: display ASCII operators as unicode symbols
; Toggle with :set conceallevel=2 / :set conceallevel=0

; Logical operators
(land) @conceal (#set! conceal "∧")
(lor) @conceal (#set! conceal "∨")
(lnot) @conceal (#set! conceal "¬")
(equiv) @conceal (#set! conceal "⇔")
(implies) @conceal (#set! conceal "⇒")

; Quantifiers
(forall) @conceal (#set! conceal "∀")
(exists) @conceal (#set! conceal "∃")
(temporal_forall) @conceal (#set! conceal "∀")
(temporal_exists) @conceal (#set! conceal "∃")
(set_in) @conceal (#set! conceal "∈")
(in) @conceal (#set! conceal "∈")

; Set operators
(cup) @conceal (#set! conceal "∪")
(cap) @conceal (#set! conceal "∩")
(subset) @conceal (#set! conceal "⊂")
(subseteq) @conceal (#set! conceal "⊆")
(supset) @conceal (#set! conceal "⊃")
(supseteq) @conceal (#set! conceal "⊇")
(notin) @conceal (#set! conceal "∉")
(setminus) @conceal (#set! conceal "∖")

; Comparison operators
(leq) @conceal (#set! conceal "≤")
(geq) @conceal (#set! conceal "≥")
(neq) @conceal (#set! conceal "≠")
(approx) @conceal (#set! conceal "≈")
(simeq) @conceal (#set! conceal "≃")
(sim) @conceal (#set! conceal "∼")
(cong) @conceal (#set! conceal "≅")
(asymp) @conceal (#set! conceal "≍")
(doteq) @conceal (#set! conceal "≐")
(gg) @conceal (#set! conceal "≫")
(ll) @conceal (#set! conceal "≪")
(prec) @conceal (#set! conceal "≺")
(preceq) @conceal (#set! conceal "⪯")
(succ) @conceal (#set! conceal "≻")
(succeq) @conceal (#set! conceal "⪰")
(propto) @conceal (#set! conceal "∝")

; Arithmetic / algebraic operators
(oplus) @conceal (#set! conceal "⊕")
(ominus) @conceal (#set! conceal "⊖")
(odot) @conceal (#set! conceal "⊙")
(oslash) @conceal (#set! conceal "⊘")
(otimes) @conceal (#set! conceal "⊗")
(div) @conceal (#set! conceal "÷")
(cdot) @conceal (#set! conceal "·")
(circ) @conceal (#set! conceal "∘")
(bullet) @conceal (#set! conceal "●")
(star) @conceal (#set! conceal "⋆")
(bigcirc) @conceal (#set! conceal "◯")
(times) @conceal (#set! conceal "×")
(uplus) @conceal (#set! conceal "⊎")
(wr) @conceal (#set! conceal "≀")

; Square operators
(sqcap) @conceal (#set! conceal "⊓")
(sqcup) @conceal (#set! conceal "⊔")
(sqsubset) @conceal (#set! conceal "⊏")
(sqsubseteq) @conceal (#set! conceal "⊑")
(sqsupset) @conceal (#set! conceal "⊐")
(sqsupseteq) @conceal (#set! conceal "⊒")

; Definition and assignment
(def_eq) @conceal (#set! conceal "≜")
(gets) @conceal (#set! conceal "≔")
(maps_to) @conceal (#set! conceal "↦")
(all_map_to) @conceal (#set! conceal "→")

; Temporal operators
(always) @conceal (#set! conceal "□")
(eventually) @conceal (#set! conceal "◇")
(leads_to) @conceal (#set! conceal "⤳")

; Delimiters
(langle_bracket) @conceal (#set! conceal "〈")
(rangle_bracket) @conceal (#set! conceal "〉")

; Keywords
"LAMBDA" @conceal (#set! conceal "λ")

; Misc
(address) @conceal (#set! conceal "→")
