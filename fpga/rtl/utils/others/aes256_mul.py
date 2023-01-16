dic = {}
GF_bit = 8
print("""
module mul256_AES (o,a,b);
output [7:0]   o;
input  [7:0] a, b;
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
for i in range(2*GF_bit-1-4):
	dic[i] = []
	dic[i].append("temp[" + str(i) + "]")
print("wire ["+str(2*GF_bit-2-4)+":0] temp2;")
for i in range(2*GF_bit-1-4, 2*GF_bit-1):
	dic[i-8].append("temp[" + str(i) + "]")
	dic[i-7].append("temp[" + str(i) + "]")
	dic[i-5].append("temp[" + str(i) + "]")
	dic[i-4].append("temp[" + str(i) + "]")
for k in dic:
	s = ("assign temp2[" + str(k) + "] = ")
	for i in range(len(dic[k])):
		if (i == len(dic[k])-1):
			s += dic[k][i] + ";"
		else:
			s += dic[k][i] + "^"
	print(s)

dic = {}
for i in range(GF_bit):
	dic[i] = []
	dic[i].append("temp2[" + str(i) + "]")
print("wire ["+str(GF_bit-1)+":0] temp3;")
for i in range(GF_bit, 2*GF_bit-1-4):
	dic[i-8].append("temp2[" + str(i) + "]")
	dic[i-7].append("temp2[" + str(i) + "]")
	dic[i-5].append("temp2[" + str(i) + "]")
	dic[i-4].append("temp2[" + str(i) + "]")
for k in dic:
	s = ("assign temp3[" + str(k) + "] = ")
	for i in range(len(dic[k])):
		if (i == len(dic[k])-1):
			s += dic[k][i] + ";"
		else:
			s += dic[k][i] + "^"
	print(s)
print("assign o = temp3;")
print("endmodule")