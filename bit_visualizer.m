% Literally just prints every single bit combination possible using 5 bits
m = 5;
M = 2^5-1;
file_name = "bit_increment_" + num2str(m) + ".txt";
fileID = fopen(file_name,'w');

for i=0:M
    fprintf(fileID, '%s\n', dec2bin(i, m));
end

fclose(fileID);