close all
clear all
clc

c = [0;0;0];

B1 = [1.1241 0.3045 0.3806; 0.3902 -0.8169 -0.3114; -0.7166 -0.8630 1.0115];
B2 = [-0.2482 0.3676 0.0328; -0.4240 0.1101 0.0267; 0.6011 -0.5975 -0.3224];

AR = {B1,B2};

Q = 1*eye(3);

Spec = vgxset('AR',AR,'Q',Q,'a',c);

n = 60000;

X = vgxsim(Spec,n);

nv = 1000;

P = orth(randn(nv,3));

Y = X*P' + 0.02*randn(n,nv);

M = 2;
m = 3;

Z = autos(Y(10001:end,:));

Z = Z*inv(sqrtm(cov(Z)))*orth(randn(nv));