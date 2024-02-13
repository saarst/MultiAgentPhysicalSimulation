function V = solveSpeed(signedDistance, vStart, vEnd, totalTime, acceleration)

syms vm t real

tm1 = abs(vm - vStart)/acceleration;
tm2 = abs(vm - vEnd)/acceleration;
tm3 = totalTime - tm1 - tm2;

v1 = vStart + acceleration*sign(vm-vStart)*t;
x1 = int(v1,t,0,tm1);

x2 = tm3 * vm ;

v3 = vm + acceleration*sign(vEnd - vm)*t;
x3 = int(v3,t,0,tm2);

x = x1 + x2 + x3;

eqn = x == signedDistance;

S = solve(eqn,vm);
for i=1:length(S)
    vm = S(i);
    V(i) = double(vm);
    tm3Candidate = double(subs(tm3));
    if tm3Candidate < 0
        V(i) = NaN;
    end
end
V = V(~isnan(V));
if length(V)>1
    warning("2 solutions");
end




end