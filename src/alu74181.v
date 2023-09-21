module ALU74181(
           input [3:0]  a,b,
           input [3:0]  s,
           input        m,
           input        notc, 
           output [3:0] f,
           output       eql,
           output       cout,
           output       pout, gout
           );
   wire [3:0]           notp;
   wire [3:0]           notg;
   wire [3:0]           c;
   wire [3:0]           sum;
   wire                 notm;

   assign notm = ~m;
      
   assign notp[0] = (a[0] & 1)            | (s[0] & b[0])         | (s[1] & ~b[0]);
   assign notp[1] = (a[1] & 1)            | (s[0] & b[1])         | (s[1] & ~b[1]);
   assign notp[2] = (a[2] & 1)            | (s[0] & b[2])         | (s[1] & ~b[2]);
   assign notp[3] = (a[3] & 1)            | (s[0] & b[3])         | (s[1] & ~b[3]);
   
   assign notg[0] = (s[2] & a[0] & ~b[0]) | (s[3] & a[0] & b[0]);
   assign notg[1] = (s[2] & a[1] & ~b[1]) | (s[3] & a[1] & b[1]);
   assign notg[2] = (s[2] & a[2] & ~b[2]) | (s[3] & a[2] & b[2]);
   assign notg[3] = (s[2] & a[3] & ~b[3]) | (s[3] & a[3] & b[3]);

   //             21: (m p0)          22: (m g0 c)
   //             23: (m p1)          24: (m p0 g1)                 25: (m c g0 g1)
   //             26: (m p2)          27: (m p1 g2)                 28: (m p0 g1 g2)                        29: (m c g0 g1 g2)
   assign c[0] = notc ~& notm;
   assign c[1] = (notm & notp[0]) ~| (notm & notg[0] & notc);
   assign c[2] = (notm & notp[1]) ~| (notm & notp[0] & notg[1]) ~| (notm & notc & notg[0] & notg[1]);
   assign c[3] = (notm & notp[2]) ~| (notm & notp[1] & notg[2]) ~| (notm & notp[0] & notg[1] & notg[2]) ~| (notm & notc & notg[0] & notg[1] & notg[2]);

   assign sum[0] = notp[0] ^ notg[0];
   assign sum[1] = notp[1] ^ notg[1];
   assign sum[2] = notp[2] ^ notg[2];
   assign sum[3] = notp[3] ^ notg[3];
   
   assign f[0] = c[0] ^ sum[0];
   assign f[1] = c[1] ^ sum[1];
   assign f[2] = c[2] ^ sum[2];
   assign f[3] = c[3] ^ sum[3];

   assign eql = f[0] & f[1] & f[2] & f[3];
   assign gout = notg[0] ~& notg[1] ~& notg[2] ~& notg[3];
   // 30: (p0 g1 g2 g3)   31: (p1 g2 g3)   32: (p2 g3)   33: (p3)
   assign pout = (notp[0] & notg[1] & notg[2] & notg[3]) ~| (notp[1] & notg[2] & notg[3]) ~| (notp[2] & notg[3]) ~| (notp[3] & 1);
   assign cout = (!(notm & notg[0] & notg[1] & notg[2] & notg[3])) | (!pout);
endmodule
