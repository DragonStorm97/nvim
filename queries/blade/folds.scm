; TODO: we don't currently fold on @X @endX groups...
((directive_start) @start
    (directive_end) @end.after
    (#set! role block))


((bracket_start) @start
    (bracket_end) @end
    (#set! role block))
