#ChipScope Core Inserter Project File Version 3.0
#Mon Aug 24 11:12:23 IST 2009

Project.unit.count=2

Project.unit<0>.type=ila
Project.unit<0>.dataPortWidth=20
Project.unit<0>.triggerPort<0000>.name=TRIG0
Project.unit<0>.triggerPortCount=1
Project.unit<0>.triggerPortIsData<0000>=false
Project.unit<0>.triggerPortWidth<0000>=4
Project.unit<0>.triggerChannel<0000><0000>=dbg_enb_trans_two_dtct
Project.unit<0>.triggerChannel<0000><0001>=dbg_trans_twodtct
Project.unit<0>.triggerChannel<0000><0002>=dbg_trans_onedtct
Project.unit<0>.triggerChannel<0000><0003>=dbg_rst_calib
Project.unit<0>.dataEqualsTrigger=false
Project.unit<0>.dataChannel<0000>=dbg_enb_trans_two_dtct
Project.unit<0>.dataChannel<0001>=dbg_trans_twodtct
Project.unit<0>.dataChannel<0002>=dbg_trans_onedtct
Project.unit<0>.dataChannel<0003>=dbg_cnt[0]
Project.unit<0>.dataChannel<0004>=dbg_cnt[1]
Project.unit<0>.dataChannel<0005>=dbg_cnt[2]
Project.unit<0>.dataChannel<0006>=dbg_cnt[3]
Project.unit<0>.dataChannel<0007>=dbg_cnt[4]
Project.unit<0>.dataChannel<0008>=dbg_cnt[5]
Project.unit<0>.dataChannel<0009>=dbg_phase_cnt[0]
Project.unit<0>.dataChannel<0010>=dbg_phase_cnt[1]
Project.unit<0>.dataChannel<0011>=dbg_phase_cnt[2]
Project.unit<0>.dataChannel<0012>=dbg_phase_cnt[3]
Project.unit<0>.dataChannel<0013>=dbg_phase_cnt[4]
Project.unit<0>.dataChannel<0014>=dbg_rst_calib
Project.unit<0>.dataChannel<0015>=dbg_delay_sel[0]
Project.unit<0>.dataChannel<0016>=dbg_delay_sel[1]
Project.unit<0>.dataChannel<0017>=dbg_delay_sel[2]
Project.unit<0>.dataChannel<0018>=dbg_delay_sel[3]
Project.unit<0>.dataChannel<0019>=dbg_delay_sel[4]
Project.unit<0>.clockChannel=clk_int
	

Project.unit<1>.type=vio
Project.unit<1>.asyncInputWidth=0
Project.unit<1>.asyncOutput<0000>=vio_out_dqs[0]
Project.unit<1>.asyncOutput<0001>=vio_out_dqs[1]
Project.unit<1>.asyncOutput<0002>=vio_out_dqs[2]
Project.unit<1>.asyncOutput<0003>=vio_out_dqs[3]
Project.unit<1>.asyncOutput<0004>=vio_out_dqs[4]
Project.unit<1>.asyncOutput<0005>=vio_out_dqs_en
Project.unit<1>.asyncOutput<0006>=vio_out_rst_dqs_div[0]
Project.unit<1>.asyncOutput<0007>=vio_out_rst_dqs_div[1]
Project.unit<1>.asyncOutput<0008>=vio_out_rst_dqs_div[2]
Project.unit<1>.asyncOutput<0009>=vio_out_rst_dqs_div[3]
Project.unit<1>.asyncOutput<0010>=vio_out_rst_dqs_div[4]
Project.unit<1>.asyncOutput<0011>=vio_out_rst_dqs_div_en
Project.unit<1>.asyncOutputWidth=12
Project.unit<1>.syncInputWidth=0
Project.unit<1>.syncOutputWidth=0
	
