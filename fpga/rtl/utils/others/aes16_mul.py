dic = {}
GF_bit = 4
print("""
module mul16_AES (o,a,b);
output [3:0]   o;
input  [3:0] a, b;
""")
print("wire ["+str(2*GF_bit-2)+":0] temp;")
for i in range(2*GF_bit-1):
	dic[i] = []
for i in range(GF_bit):
	for j in range(GF_bit):
		dic[i+j].append("(a[" + str(i) + "] & b[" + str(j) + "])")
for k in dic:
	s = ("assign temp[" + str(k) + "] = ")
	for i in range(len(dic[k])):
		if (i == len(dic[k])-1):
			s += dic[k][i] + ";"
		else:
			s += dic[k][i] + "^"
	print(s)

dic = {}
for i in range(2*GF_bit-1-3):
	dic[i] = []
	dic[i].append("temp[" + str(i) + "]")
print("wire ["+str(2*GF_bit-2-3)+":0] temp2;")
for i in range(GF_bit, 2*GF_bit-1):
	dic[i-4].append("temp[" + str(i) + "]")
	dic[i-3].append("temp[" + str(i) + "]")
for k in dic:
	s = ("assign temp2[" + str(k) + "] = ")
	for i in range(len(dic[k])):
		if (i == len(dic[k])-1):
			s += dic[k][i] + ";"
		else:
			s += dic[k][i] + "^"
	print(s)


print("assign o = temp2;")
print("endmodule")