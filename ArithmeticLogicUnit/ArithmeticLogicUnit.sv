///////////////////////////////////////////////////////////////
// Authors: ANONYMOUS and Alexander Evans Moncloa
// Date: 13/12/2022
// Module name: ArithmeticLogicUnit
// Description: The unit that processes arithmetics
///////////////////////////////////////////////////////////////

import InstructionSetPkg::*;

// Define the connections into and out of the ALU.
module ArithmeticLogicUnit
(
	// The Operation variable is an example of an enumerated type and
	// is defined in InstructionSetPkg.
	input eOperation Operation,
	
	// The InFlags and OutFlags variables are examples of structures
	// which have been defined in InstructionSetPkg. They group together
	// all the single bit flags described by the Instruction set.
	input  sFlags    InFlags,
	output sFlags    OutFlags,
	
	// All the input and output busses have widths determined by the 
	// parameters defined in InstructionSetPkg.
	input  signed [ImmediateWidth-1:0] InImm,
	
	// InSrc and InDest are the values in the source and destination
	// registers at the start of the instruction.
	input  signed [DataWidth-1:0] InSrc,
	input  signed [DataWidth-1:0]	InDest,
	
	// OutDest is the result of the ALU operation that is written 
	// into the destination register at the end of the operation.
	output logic signed [DataWidth-1:0] OutDest
);

	// This block allows each OpCode to be defined. Any opcode not
	// defined outputs a zero. The names of the operation are defined 
	// in the InstructionSetPkg. 
	always_comb
	begin
	
		// By default the flags are unchanged. Individual operations
		// can override this to change any relevant flags.
		OutFlags  = InFlags;
		
		// The basic implementation of the ALU only has the NAND and
		// ROL operations as examples of how to set ALU outputs 
		// based on the operation and the register / flag inputs.
		case(Operation)		
		
			ROL:     {OutFlags.Carry,OutDest} = {InSrc,InFlags.Carry};	
			
			NAND:    OutDest = ~(InSrc & InDest);

			LIL:	 OutDest = $signed(InImm);

			LIU:
				 begin
					if (InImm[ImmediateWidth - 1] ==  1)
						OutDest = {InImm[ImmediateWidth - 2:0], InDest[ImmediateHighStart - 1:0]};
					else if  (InImm[ImmediateWidth - 1] ==  0)	
						OutDest = $signed({InImm[ImmediateWidth - 2:0], InDest[ImmediateMidStart - 1:0]});
					else
						OutDest = InDest;	
				 end

			// ***** ONLY CHANGES BELOW THIS LINE ARE ASSESSED *****
			// Put your instruction implementations here.
			
			MOVE:		OutDest = InSrc;
			
			NOR:		OutDest = ~(InSrc | InDest);
			
			ROR: 		{OutDest,OutFlags.Carry} = {InFlags.Carry,InSrc};
			
			ADC:		begin
						//OutDest = InSrc + InDest + InFlags.Carry;
						{OutFlags.Carry,OutDest} = InSrc + InDest + InFlags.Carry;
						if (OutDest == 0) OutFlags.Zero = 1;
						else OutFlags.Zero = 0;

						if (OutDest < 0) OutFlags.Negative = 1;
						else OutFlags.Negative = 0;
						
						if (((~InDest[DataWidth-1] & ~InSrc[DataWidth-1]) & OutDest[DataWidth-1])|((InDest[DataWidth-1] & InSrc[DataWidth-1]) & ~OutDest[DataWidth-1]))
							OutFlags.Overflow = 1;
						//if ((InDest[DataWidth-1] == InSrc[DataWidth-1]) ^ (OutDest[DataWidth-1]))
						else OutFlags.Overflow = 0;

						if (~^OutDest == 1) OutFlags.Parity = 1;
						else OutFlags.Parity = 0;
						
						//{OutFlags.Carry,OutDest} = InDest + InSrc;
					end
						
			SUB:		begin
						{OutFlags.Carry,OutDest} = InDest - (InSrc + InFlags.Carry );

						if (OutDest == 0) OutFlags.Zero = 1;
						else OutFlags.Zero = 0;

						if (OutDest < 0) OutFlags.Negative = 1;
						else OutFlags.Negative = 0;
						
						if (((~InDest[DataWidth-1] & InSrc[DataWidth-1]) & OutDest[DataWidth-1])|((InDest[DataWidth-1] & ~InSrc[DataWidth-1]) & ~OutDest[DataWidth-1]))
							OutFlags.Overflow = 1;
						else OutFlags.Overflow = 0;
						//if (InDest[DataWidth-1] ^ (InSrc[DataWidth-1] == OutDest[DataWidth-1]))
							

						if (~^OutDest == 1) OutFlags.Parity = 1;
						else OutFlags.Parity = 0;

						//{OutFlags.Carry,OutDest} = InDest + InSrc;
					end
			
			DIV:		begin
						OutDest = InDest/InSrc;

						if (OutDest == 0) OutFlags.Zero = 1;
						else OutFlags.Zero = 0;

						if (OutDest < 0) OutFlags.Negative = 1;
						else OutFlags.Negative = 0;

						if (~^OutDest == 1) OutFlags.Parity = 1;
						else OutFlags.Parity = 0;

					end

			MOD:		begin
						OutDest = InDest % InSrc;

						if (OutDest == 0) OutFlags.Zero = 1;
						else OutFlags.Zero = 0;

						if (OutDest < 0) OutFlags.Negative = 1;
						else OutFlags.Negative = 0;

						if (~^OutDest == 1) OutFlags.Parity = 1;
						else OutFlags.Parity = 0;

					end

			MUL:		begin
						OutDest = (InDest * InSrc);

						if (OutDest == 0) OutFlags.Zero = 1;
						else OutFlags.Zero = 0;

						if (OutDest < 0) OutFlags.Negative = 1;
						else OutFlags.Negative = 0;

						if (~^OutDest == 1) OutFlags.Parity = 1;
						else OutFlags.Parity = 0;

					end

			MUH:		begin
						OutDest = (InDest * InSrc)/ ( 2 ** ( DataWidth)) ; // Copyright MAX + ALEXANDER, PATENT no 6515655, not for use by other students who try to hard code it

						if (OutDest == 0) OutFlags.Zero = 1;
						else OutFlags.Zero = 0;

						if (OutDest < 0) OutFlags.Negative = 1;
						else OutFlags.Negative = 0;

						if (~^OutDest == 1) OutFlags.Parity = 1;
						else OutFlags.Parity = 0;

					end
				
			// ***** ONLY CHANGES ABOVE THIS LINE ARE ASSESSED	*****		
			
			default:	OutDest = '0;
			
		endcase;
	end

endmodule
