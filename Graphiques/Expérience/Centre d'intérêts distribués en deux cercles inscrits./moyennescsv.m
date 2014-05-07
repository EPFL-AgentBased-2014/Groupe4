A = csvread("moyennes.csv");

a = 121;
b = 501;
c = 0;

for i = 1:a
	sum_z1 = 0;
	sum_z2 = 0;
	sum_z3 = 0;
	sum_z4 = 0;
	sum_nb_groups = 0;
	
	for j = 6:b
		sum_z1 = sum_z1 + A(j + (i-1)*b,3);
		sum_z2 = sum_z2 + A(j + (i-1)*b,4);
		sum_z3 = sum_z3 + A(j + (i-1)*b,5);
		sum_z4 = sum_z4 + A(j + (i-1)*b,6);
		sum_nb_groups = sum_nb_groups + A(j + (i-1)*b,7);
	end
	
	poll_rate(i) = A(1 + (i-1)*b,1);
	vision(i) = A(1 + (i-1)*b,2);
	happy_regroup(i) = sum_z1/4.95;
	happy_pollution(i) = sum_z2/4.95;
	happy(i) = sum_z3/4.95;
	pc_pollution(i) = sum_z4/495;
	groups(i) = sum_nb_groups/495;
end

% - - - - - - - - - - - - - - - - - - -

l = 1;

for j = 1:11
	for k = 1:11
		Poll_rate(k,j) = poll_rate(l);
		Vision(k,j) = vision(l);
		Happy_regroup(k,j) = happy_regroup(l);
		Happy_pollution(k,j) = happy_pollution(l);
		Happy(k,j) = happy(l);
		Pc_pollution(k,j) = pc_pollution(l);
		Groups(k,j) = groups(l);
		l = l+1;
	end
end


% plots - - - - - - - - - - - - - - - -


figure(1)
p = surf(Vision, Poll_rate, Happy)
xlabel("Vision");
ylabel("% Pollution rate");
zlabel("% Happy")
print("Happy", "-dpng")

figure(2)
p = surf(Vision, Poll_rate, Happy_regroup)
xlabel("Vision");
ylabel("% Pollution rate");
zlabel("% Happy regroup")
print("Happy-regroup", "-dpng")

figure(3)
p = surf(Vision, Poll_rate, Happy_pollution)
xlabel("Vision");
ylabel("% Pollution rate");
zlabel("% Happy polution")
print("Happy-pollution", "-dpng")

figure(4)
p = surf(Vision, Poll_rate, Pc_pollution)
xlabel("Vision");
ylabel("% Pollution rate");
zlabel("% Pollution")
print("Polluton_pc", "-dpng")

figure(5)
p = surf(Vision, Poll_rate, Groups)
xlabel("Vision");
ylabel("Pollution rate");
zlabel("# Groups")
print("Groups", "-dpng")

