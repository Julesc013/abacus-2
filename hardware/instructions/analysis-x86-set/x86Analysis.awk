# x86 Machine Code Statistics
# (c) Peter Kankowski, 2006   http://www.smallcode.weblogs.us
BEGIN {
  FIELDWIDTHS = "8 5 15 41"
  # prepare array with register names
  split("AL BL CL DL AH BH CH DH AX BX CX DX SP BP SI DI EAX ECX EDX EBX ESP EBP ESI EDI " \
   "ST ST(0) ST(1) ST(2) ST(3) ST(4) ST(5) ST(6) ST(7) " \
   "MM0 MM1 MM2 MM3 MM4 MM5 MM6 MM7 XMM0 XMM1 XMM2 XMM3 XMM4 XMM5 XMM6 XMM7", sregs, " ")
  for(r in sregs)
     regs[sregs[r]] = r
}
NF >= 4 {
  if($4 ~ /^DB .*/ || $4 ~ /^DW .*/ || $4 ~ /^DD .*/ || $4 ~ /^ASCII .*/) {
     oldaddr = strtonum("0x" $1)
     next
  }
  instruction = $4
  sub(/^[^A-Za-z0-9]*/, "", instruction) # skip leading spaces and pseudo-graphical garbage
  if(sub(/^REP /, "", instruction)) # strip prefixes
     mnemonics["REP"]++
  else if(sub(/^REPE /, "", instruction))
     mnemonics["REPE"]++
  else if(sub(/^REPNE /, "", instruction))
     mnemonics["REPNE"]++
  else if(sub(/^LOCK /, "", instruction))
     mnemonics["LOCK"]++
  a = index(instruction, " ") # split into mnemonic and operands
  mnemonic = substr(instruction, 1, a - 1)
  operands = substr(instruction, a + 1)
  if(a == 0)
     mnemonic = instruction # if no operands
  mnemonics[mnemonic]++
  num = split(operands, op_arr, ",") # split operands
  opnums[num]++
  for(op in op_arr) {
     if(op_arr[op] in regs) # e.g., PUSH EAX or MOV EDI,EAX
        op_types["register "]++
     else if(substr(op_arr[op], 1, 1) == "[") { # memory operand
        if(sub(/^\[DWORD /, "", op_arr[op]))
            op_size["dword  "]++
        else if(sub(/^\[WORD /, "", op_arr[op]))
            op_size["word   "]++
        else if(sub(/^\[BYTE /, "", op_arr[op]))
            op_size["byte   "]++
        else if(sub(/^\[DQWORD /, "", op_arr[op]))
            op_size["dqword "]++
        else if(sub(/^\[XMMWORD /, "", op_arr[op]))
            op_size["xmmword"]++
        else if(sub(/^\[QWORD /, "", op_arr[op]))
            op_size["qword  "]++
        else { # no size of operand (the option "Always show size of memory operands" is off)
            op_arr[op] = substr(op_arr[op], 2)
            warn_nosize = 1
        }
        sub(/^DS:/, "", op_arr[op])
        sub(/^SS:/, "", op_arr[op])
        sub(/^ES:/, "", op_arr[op])
        if(substr(op_arr[op], 1, 3) in regs) # something like [DWORD SS:EBP-10]
            op_types["indirect "]++
        else                                 # something like [DWORD DS:402474] or [DWORD DS:<&USER32.LoadCursorA>]
            op_types["abs_addr "]++
     } else # a number or an address for jumps, e.g. PUSH 10 or JNZ SHORT test.004018F4
        op_types["immediate"]++
     operands_count++
  }
  if(oldaddr)
    instrlens[strtonum("0x" $1) - oldaddr]++
  oldaddr = strtonum("0x" $1)
  instructions_count++
}
END {
  print "~~~  TOP INSTRUCTIONS  ~~~"
  # out to auxiliary array
  i = 1
  for(m in mnemonics)
     out[i++] = sprintf("%5.2f%% %s", mnemonics[m] * 100 / instructions_count, m)
  asort(out)
  end = (full || i <= 20) ? 1 : i - 20
  for(j = i - 1; j >= end; --j)
     print out[j]
  print ""
  print "~~~  INSTRUCTIONS LENGTH  ~~~"
  maxlen = getmax(instrlens)
  printf " 1 byte  %s %.2f%%\n", makestring("=", instrlens[1] * 60 / maxlen),
         instrlens[1] * 100 / instructions_count
  for(i = 2; i <= 11; ++i)
     printf "%2d bytes %s %.2f%%\n", i, makestring("=", instrlens[i] * 60 / maxlen),
            instrlens[i] * 100 / instructions_count
  print ""
  print "~~~  NUMBER OF OPERANDS  ~~~"
  for(i = 0; i <= 2; ++i)
     printf "%d operands %5.2f%%\n", i, opnums[i] * 100 / instructions_count
  print ""
  print "~~~  TYPE OF OPERANDS  ~~~"
  maxcount = getmax(op_types)
  for(i in op_types)
     printf "%s %s %5.2f%%\n", i, makestring("=", op_types[i] * 60 / maxcount),
            op_types[i] * 100 / operands_count
  print ""
  print "~~~  SIZE OF MEMORY OPERANDS  ~~~"
  if(warn_nosize)
     print "Error: Check Always show size of memory operands"
  else {
     maxsize = getmax(op_size)
     for(i in op_size)
        printf "%s %s %5.2f%%\n", i, makestring("=", op_size[i] * 60 / maxsize),
               op_size[i] * 100 / (op_types["indirect "] + op_types["abs_addr "])
  }
}
function makestring(character, repcount,    s, k) {
  for(k = 1; k <= repcount; ++k)
     s = s character
  return s
}
function getmax(arr,  i, max) {
  for(i in arr)
     if(arr[i] > max)
        max = arr[i]
  return max
}