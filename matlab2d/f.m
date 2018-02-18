function [ fx, fy ] = f(u)

gr = 9.81;

h = u(1);
hu = u(2);
hv = u(3);

if(h <= 0)
    fx =[0;0;0];
    fy =[0;0;0];
else

    huv = hu * hv / h;

    fx = [hu ; hu*hu/h + gr*h*h/2; huv];

    fy = [hv; huv; hv*hv/h + gr*h*h/2];
end

end

