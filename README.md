# Logical-Statement-Analyzer
 A little program that analyzes logical statements and gives you True/False results.

Written in PowerBASIC.

I originally wrote this program after taking a logic class in college (the original version was written in Qbasic or something like that).  It allows you to enter a logical statement consisting of various symbols, and then it analyzes it and gives you the result in the form of T (for True) or F (for False).

The symbols consist of the following:

T is for True
F is for False
() are used for logical grouping
[] are used for logical grouping
{} are used for logical grouping
& is for AND
| is for OR
~ is for NOT
; is the If-Then operator
= is the equality operator

EXAMPLES:

T|F
This would evaluate to True (True OR False).

~F
This would evaluate to True (NOT False).

F|(T&F)
This would evaluate to False; the True AND False
inside the parentheses is False, therefore False
OR False is, of course, False.

T=F
This evaluates to False (True does not equal
False).

If-Then conditionals always evaluate to True
unless the antecedent on the left is True and
the consequent on the right is False, in which
case it evaluates to False:

T;[T&(~T)]
This evaluates to False.  In the parentheses, we
have NOT True, which is False; therefore, in the
brackets we have True AND False, which is False;
therefore, IF True THEN False evaluates to False.

I hope you enjoy this program and maybe even find it useful for certain applications.  I made this updated version using PowerBASIC that incorporates a GUI simply because I wanted it to be easier to use with more capabilities.