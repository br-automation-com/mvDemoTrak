
ACTION ClockPulse: 

(*ClockPulse Slow*)
TP_PulseOnSlow(IN := NOT(TP_PulseOffSlow.Q) , PT := T#1000ms);
TP_PulseOffSlow(IN := NOT(TP_PulseOnSlow.Q) , PT := T#1000ms);
(*ClockPulse Medium*)
TP_PulseOnMed(IN := NOT(TP_PulseOffMed.Q) , PT := T#500ms);
TP_PulseOffMed(IN := NOT(TP_PulseOnMed.Q) , PT := T#500ms);
(*ClockPulse Flash*)
TP_PulseOnFlash(IN := NOT(TP_PulseOffFlash.Q) , PT := T#250ms);
TP_PulseOffFlash(IN := NOT(TP_PulseOnFlash.Q) , PT := T#250ms);

END_ACTION
