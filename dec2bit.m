function vector=dec2bit(x,size)
if x< 0.0 
tmp = 2- abs(x);
else 
    tmp=abs(x);
end;
	 for i = 1:size  
	     if tmp >=1.0  
	      vector(size+1-i)='1';
			tmp= tmp-1.0;
			 else 
			  vector(size+1 -i)='0';
         end;
         tmp = 2.0 * tmp;
     end 
	 