
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

public class Tb {
	public void convert(){
		File file = new File("/Users/apple/Desktop/", "demo.txt");
		BufferedReader reader = null;
		try{
			System.out.println("read by line");
			reader = new BufferedReader(new FileReader(file));
			String tempString = null;
			int line = 1;
			while((tempString = reader.readLine()) != null){
				System.out.println("line" + line + ": " + tempString );
				int index = tempString.indexOf('/');
				String ns;
				if(index != -1)
					ns = tempString.substring(0, index);
				else 
					ns = tempString;
				ns.trim();
				String ws = covertToBit(ns.toUpperCase());
				writeFile(ws);
				line++;
			}
		}catch(IOException e){
			e.printStackTrace();
		} finally{
			if(reader != null){
				try{
					reader.close();
				}catch(IOException e1){
					e1.printStackTrace();
				}
			}
		}
	}
	
	public String covertToBit(String s){
		StringBuilder sb = new StringBuilder();
		String[] ss;
		if(((s.startsWith("ADD") || s.startsWith("SUB") || s.startsWith("AND") || s.startsWith("OR"))
			 && s.charAt(3) != 'I') || s.startsWith("NOR")){
			sb.append("000000");
			ss = s.split(",");
			sb = constructSb(ss, sb);
			sb.append("00000");
			if(s.startsWith("ADD")) sb.append("010000");
			else if(s.startsWith("SUB")) sb.append("010001");
			else if(s.startsWith("AND")) sb.append("010010");
			else if(s.startsWith("OR")) sb.append("010011");
			else if(s.startsWith("NOR")) sb.append("010100");
		}else if(s.startsWith("JMP")) sb.append("001100"); 
		else if(s.startsWith("HAL"))  sb.append("11111100000000000000000000000000");
		else {
			ss = s.split(",");
			if(s.startsWith("ADDI")) sb.append("000001");
			else if(s.startsWith("SUBI")) sb.append("000010");
			else if(s.startsWith("ANDI")) sb.append("000011");
			else if(s.startsWith("ORI"))  sb.append("000100");
			else if(s.startsWith("SHL"))  sb.append("000101");
			else if(s.startsWith("SHR"))  sb.append("000110");
			else if(s.startsWith("LW"))   sb.append("000111");
			else if(s.startsWith("SW"))   sb.append("001000");
			else if(s.startsWith("BLT"))  sb.append("001001");
			else if(s.startsWith("BEQ"))  sb.append("001010");
			else if(s.startsWith("BNE"))  sb.append("001011");
			sb = constructSb1(ss, sb);
		}
		return sb.toString();
	}
	
	public StringBuilder constructSb(String[] ss, StringBuilder sb){
		int index, a;
		String s, bits, subbits = "";
		for(int i = ss.length - 1; i >=1; i--){
			index = ss[i].indexOf("R");
			s = ss[i].substring(index + 1).trim();
			a = Integer.parseInt(s);
			bits = Integer.toBinaryString(a);
			if(bits.length() < 5){
				int count = 5 - bits.length();
				while(count > 0){
					subbits += "0";
					count--;
				}
				
			}
			subbits += bits;
			sb.append(subbits);
			subbits = "";
		}
		index = ss[0].lastIndexOf("R");
		s = ss[0].substring(index + 1).trim();
		a = Integer.parseInt(s);
		subbits = "";
		bits = Integer.toBinaryString(a);
		if(bits.length() < 5){
			int count = 5 - bits.length();
			while(count > 0){
				subbits += "0";
				count--;
			}
			
		}
		subbits += bits;
		sb.append(subbits);
		return sb;
	}
	
	public StringBuilder constructSb1(String[] ss, StringBuilder sb){
		int index, a;
		String s, bits, subbits = "";

		if(ss.length < 3) return constructSb2(ss, sb);
		if(ss[2].startsWith("0x")) {sb.append(ss[2] + "------------------------"); return sb;}
		for(int i = 1; i >= 0; i--){
			index = ss[i].lastIndexOf("R");
			s = ss[i].substring(index + 1).trim();
			a = Integer.parseInt(s);
			bits = Integer.toBinaryString(a);
			if(bits.length() < 5){
				int count = 5 - bits.length();
				while(count > 0) {subbits += "0"; count--;}
			}
			subbits += bits;
			sb.append(subbits);
			subbits = "";
		}
		s = ss[2].trim();
		a = Integer.parseInt(s);
		subbits = "";
		bits = Integer.toBinaryString(a);
		if(bits.length() < 16){
			int count = 16 - bits.length();
			while(count > 0) {subbits += "0"; count--;}
		}else{
			bits = bits.substring(16);
		}
		subbits += bits;
		sb.append(subbits);
		return sb;
	}
	
	
	public StringBuilder constructSb2(String[] ss, StringBuilder sb){
		int index, index2, a;
		String s, bits, subbits = "";
		index = ss[1].indexOf("R");
		index2 = ss[1].indexOf(")");
		s = ss[1].substring(index + 1, index2).trim();
		a = Integer.parseInt(s);
		bits = Integer.toBinaryString(a);
		if(bits.length() < 5){
			int count = 5 - bits.length();
			while(count > 0) {subbits += "0"; count--;}
		}
		subbits += bits;
		sb.append(subbits);
		subbits = "";
		index = ss[0].indexOf("R");
		s = ss[0].substring(index + 1).trim();
		a = Integer.parseInt(s);
		bits = Integer.toBinaryString(a);
		if(bits.length() < 5){
			int count = 5 - bits.length();
			while(count > 0) {subbits += "0"; count--;}
		}
		subbits += bits;
		sb.append(subbits);
		sb.append("0000000000000000");
		return sb;
	}
	public void writeFile(String s){
		try{
			File file = new File("binaryfile.txt");
			//File file = new File("testbit.txt");
			if(!file.exists()){
				file.createNewFile();
			}
			FileWriter fw = new FileWriter(file.getName(), true);
			BufferedWriter bw = new BufferedWriter(fw);
			bw.write("\"" + s + "\"" + "," + "\n");
			//bw.write("\"" + "11111100000000000000000000000000" + "\"" + "," + "\n");
			bw.close();
		}catch(IOException e){
			e.printStackTrace();
		}
		
	}

}
