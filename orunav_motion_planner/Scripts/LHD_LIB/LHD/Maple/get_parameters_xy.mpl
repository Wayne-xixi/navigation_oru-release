#
# forward motion (acceleration constraint at t_0 and t_T)
#

#--------------------------------------------------------------------------------
# Loading libraries
#--------------------------------------------------------------------------------
with(LinearAlgebra):
with(codegen, C, makeproc):
#--------------------------------------------------------------------------------

t_0 := 0:
t_T := 1:
A := Matrix([[   t_0^5,    t_0^4,    t_0^3,    t_0^2,  t_0,  1],
             [   t_T^5,    t_T^4,    t_T^3,    t_T^2,  t_T,  1],
             [ 5*t_0^4,  4*t_0^3,  3*t_0^2,   2*t_0 ,    1,  0],
             [ 5*t_T^4,  4*t_T^3,  3*t_T^2,   2*t_T ,    1,  0],
             [20*t_0^3, 12*t_0^2,  6*t_0  ,   2     ,    0,  0],
             [20*t_T^3, 12*t_T^2,  6*t_T  ,   2     ,    0,  0]]):

b_x := < x_0; x_T; k_0*cos(theta_0); k_T*cos(theta_T); a0_x; aT_x>:
b_y := < y_0; y_T; k_0*sin(theta_0); k_T*sin(theta_T); a0_y; aT_y>:

iA := MatrixInverse(A):
p_x := iA.b_x:
p_y := iA.b_y:

all := ArrayTools:-Concatenate(2,convert(p_x,vector),convert(p_y,vector)):

get_parameters_xy := makeproc(all,[a0_x, a0_y, aT_x, aT_y, k_0, k_T, x_0, y_0, theta_0, x_T, y_T, theta_T]):

fd := fopen("get_parameters_xy.c",WRITE):
fprintf(fd,"/* drdv: generated using codegen (%s) */\n", StringTools:-FormatTime("%Y-%m-%d, %T")):
fclose(fd):

C(get_parameters_xy, optimized, filename = "get_parameters_xy.c"):