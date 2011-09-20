/****************************************************************************************
*
*   Disclaimer   This software code and all associated documentation, comments or other 
*  of Warranty:  information (collectively "Software") is provided "AS IS" without 
*                warranty of any kind. MICRON TECHNOLOGY, INC. ("MTI") EXPRESSLY 
*                DISCLAIMS ALL WARRANTIES EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED 
*                TO, NONINFRINGEMENT OF THIRD PARTY RIGHTS, AND ANY IMPLIED WARRANTIES 
*                OF MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE. MTI DOES NOT 
*                WARRANT THAT THE SOFTWARE WILL MEET YOUR REQUIREMENTS, OR THAT THE 
*                OPERATION OF THE SOFTWARE WILL BE UNINTERRUPTED OR ERROR-FREE. 
*                FURTHERMORE, MTI DOES NOT MAKE ANY REPRESENTATIONS REGARDING THE USE OR 
*                THE RESULTS OF THE USE OF THE SOFTWARE IN TERMS OF ITS CORRECTNESS, 
*                ACCURACY, RELIABILITY, OR OTHERWISE. THE ENTIRE RISK ARISING OUT OF USE 
*                OR PERFORMANCE OF THE SOFTWARE REMAINS WITH YOU. IN NO EVENT SHALL MTI, 
*                ITS AFFILIATED COMPANIES OR THEIR SUPPLIERS BE LIABLE FOR ANY DIRECT, 
*                INDIRECT, CONSEQUENTIAL, INCIDENTAL, OR SPECIAL DAMAGES (INCLUDING, 
*                WITHOUT LIMITATION, DAMAGES FOR LOSS OF PROFITS, BUSINESS INTERRUPTION, 
*                OR LOSS OF INFORMATION) ARISING OUT OF YOUR USE OF OR INABILITY TO USE 
*                THE SOFTWARE, EVEN IF MTI HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH 
*                DAMAGES. Because some jurisdictions prohibit the exclusion or 
*                limitation of liability for consequential or incidental damages, the 
*                above limitation may not apply to you.
*
*                Copyright 2003 Micron Technology, Inc. All rights reserved.
*
****************************************************************************************/

    // Timing parameters based on Speed Grade

`define custom_part

  `define custom_speed_grade
      parameter tCK              =     5.0; // tCK    ns    Nominal Clock Cycle Time
      parameter tDQSQ            =     0.45; // tDQSQ  ns    DQS-DQ skew, DQS to last DQ valid, per group, per access
      parameter tMRD        = 10;   // tMRD  ns Load Mode Register command cycle time
      parameter tRAP        = 15.0;   // tRAP  ns ACTIVE to READ with Auto precharge command
      parameter tRAS        = 42;   // tRAS  ns Active to Precharge command time
      parameter tRC         = 55;    // tRC   ns Active to Active/Auto Refresh command time
      parameter tRFC        = 72;   // tRFC  ns Refresh to Refresh Command interval time
      parameter tRCD        = 15;   // tRCD  ns Active to Read/Write command time
      parameter tRP         = 15;    // tRP   ns Precharge command period
      parameter tRRD        = 10.0;   // tRRD  ns Active bank a to Active bank b command time
      parameter tWR         = 15;    // tWR   ns Write recovery time
  
// Size Parameters based on Part Width
  
  `define custom_part_width
      parameter ADDR_BITS   = 13;    // Set this parameter to control how many Address bits are used
      parameter DQ_BITS     = 8;  // Set this parameter to control how many Data bits are used
      parameter DQS_BITS    = 1; // Set this parameter to control how many DQS bits are used
      parameter DM_BITS     = 1;  // Set this parameter to control how many DM bits are used
      parameter COL_BITS    = 11;        // Set this parameter to control how many Column bits are used
  

    parameter BA_BITS       = 2;                    // Set this parmaeter to control how many Bank Address bits are used
    parameter full_mem_bits = BA_BITS+ADDR_BITS+COL_BITS; // Set this parameter to control how many unique addresses are used
    parameter part_mem_bits = 12;                         // Set this parameter to control how many unique addresses are used

    parameter no_halt       = 1; // If set to 1, the model won't halt on command sequence/major errors
    parameter DEBUG         = 1; // Turn on DEBUG message