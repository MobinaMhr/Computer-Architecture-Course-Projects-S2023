`timescale 1ns/1ns

module ratInMazeTB();
        reg _clk = 1'b0;
        reg _rst = 1'b0;
        reg _start = 1'b0;
        reg _run = 1'b0;
        wire _fail, _done;
        wire [7:0] _move;

        ratInMaze rtInMz (.clk(_clk), .rst(_rst), .start(_start), .run(_run), .fail(_fail), .done(_done), .move(_move));

        always #5 _clk <= ~_clk;
        initial begin
                #2;
                _rst = 1'b1;
                #4;
                _rst = 1'b0;
                _start = 1'b1;
                #12;
                _start = 1'b0;
                #35000;
                _run = 1'b1;
                #800 $stop;
        end
endmodule