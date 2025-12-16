module relu
(
    input  int  in_relu,
    output int  out_relu
);
    assign  out_relu = (in_relu > 0) ? in_relu : 0;
endmodule
