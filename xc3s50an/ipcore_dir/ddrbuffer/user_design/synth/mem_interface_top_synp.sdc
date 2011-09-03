define_global_attribute         syn_global_buffers {2}
define_attribute          {v:work.ddrbuffer_parameters_0} syn_hier {hard}
define_attribute          {v:work.ddrbuffer} syn_hier {hard}
define_attribute          {v:work.ddrbuffer_cal_ctl} syn_hier {hard}
define_attribute          {v:work.ddrbuffer_cal_top} syn_hier {hard}
define_attribute          {v:work.ddrbuffer_controller_0} syn_hier {hard}
define_attribute          {v:work.ddrbuffer_controller_iobs_0} syn_hier {hard}
define_attribute          {v:work.ddrbuffer_data_path_0} syn_hier {hard}
define_attribute          {v:work.ddrbuffer_data_path_iobs_0} syn_hier {hard}
define_attribute          {v:work.ddrbuffer_data_read_0} syn_hier {hard}
define_attribute          {v:work.ddrbuffer_data_read_controller_0} syn_hier {hard}
define_attribute          {v:work.ddrbuffer_data_write_0} syn_hier {hard}
define_attribute          {v:work.ddrbuffer_dqs_delay_0} syn_hier {hard}
define_attribute          {v:work.ddrbuffer_fifo_0_wr_en_0} syn_hier {hard}
define_attribute          {v:work.ddrbuffer_fifo_1_wr_en_0} syn_hier {hard}
define_attribute          {v:work.ddrbuffer_infrastructure} syn_hier {hard}
define_attribute          {v:work.ddrbuffer_infrastructure_iobs_0} syn_hier {hard}
define_attribute          {v:work.ddrbuffer_infrastructure_top0} syn_hier {hard}
define_attribute          {v:work.ddrbuffer_iobs_0} syn_hier {hard}
define_attribute          {v:work.ddrbuffer_ram8d_0} syn_hier {hard}
define_attribute          {v:work.ddrbuffer_rd_gray_cntr} syn_hier {hard}
define_attribute          {v:work.ddrbuffer_s3_dm_iob} syn_hier {hard}
define_attribute          {v:work.ddrbuffer_s3_dq_iob} syn_hier {hard}
define_attribute          {v:work.ddrbuffer_s3_dqs_iob} syn_hier {hard}
define_attribute          {v:work.ddrbuffer_tap_dly} syn_hier {hard}
define_attribute          {v:work.ddrbuffer_top_0} syn_hier {hard}
define_attribute          {v:work.ddrbuffer_wr_gray_cntr} syn_hier {hard}

#clock constraints
 define_clock  -name {n:clk_int}  -period 7.519 -clockgroup default_clkgroupclk_int
 define_clock  -name {n:clk90_int}  -period 7.519 -clockgroup default_clkgroupclk90_int


