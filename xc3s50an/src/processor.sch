<?xml version="1.0" encoding="UTF-8"?>
<drawing version="7">
    <attr value="spartan3a" name="DeviceFamilyName">
        <trait delete="all:0" />
        <trait editname="all:0" />
        <trait edittrait="all:0" />
    </attr>
    <netlist>
        <signal name="XLXN_3" />
        <signal name="CYCLK" />
        <signal name="MEMCLK" />
        <signal name="STATECLK" />
        <signal name="RESET" />
        <signal name="CYINT" />
        <signal name="MEMDATA_IN(15:0)" />
        <signal name="ADCSEL(1:0)" />
        <signal name="XLXN_22" />
        <signal name="ADCCLKSEL(2:0)" />
        <signal name="MEMCTRL(2:0)" />
        <signal name="XLXN_74(2:0)" />
        <signal name="XLXN_75(2:0)" />
        <signal name="STOP" />
        <signal name="XLXN_77" />
        <signal name="STOPPED" />
        <signal name="XLXN_85" />
        <signal name="XLXN_86" />
        <signal name="CYDATA_IN(15:0)" />
        <signal name="XLXN_1(15:0)" />
        <signal name="ADCCLK" />
        <signal name="MEMADDR(25:0)" />
        <signal name="MEMDATAMASK(1:0)" />
        <signal name="MEMDATA_OUT(15:0)" />
        <signal name="CYDATA_OUT(15:0)" />
        <signal name="XLXN_193" />
        <signal name="ADCVALID" />
        <signal name="ADCDATA(15:0)" />
        <signal name="XLXN_202">
        </signal>
        <signal name="XLXN_203" />
        <signal name="XLXN_204" />
        <signal name="XLXN_212(15:0)" />
        <signal name="XLXN_216(15:0)" />
        <signal name="CYWR_STROBE" />
        <signal name="MEMDONE" />
        <signal name="XLXN_223(63:0)" />
        <signal name="XLXN_224(15:0)" />
        <port polarity="Input" name="CYCLK" />
        <port polarity="Input" name="MEMCLK" />
        <port polarity="Input" name="STATECLK" />
        <port polarity="Input" name="RESET" />
        <port polarity="Input" name="CYINT" />
        <port polarity="Input" name="MEMDATA_IN(15:0)" />
        <port polarity="Output" name="ADCSEL(1:0)" />
        <port polarity="Output" name="ADCCLKSEL(2:0)" />
        <port polarity="Output" name="MEMCTRL(2:0)" />
        <port polarity="Output" name="STOP" />
        <port polarity="Input" name="STOPPED" />
        <port polarity="Input" name="CYDATA_IN(15:0)" />
        <port polarity="Input" name="ADCCLK" />
        <port polarity="Output" name="MEMADDR(25:0)" />
        <port polarity="Output" name="MEMDATAMASK(1:0)" />
        <port polarity="Output" name="MEMDATA_OUT(15:0)" />
        <port polarity="Output" name="CYDATA_OUT(15:0)" />
        <port polarity="Input" name="ADCVALID" />
        <port polarity="Input" name="ADCDATA(15:0)" />
        <port polarity="Output" name="CYWR_STROBE" />
        <port polarity="Output" name="MEMDONE" />
        <blockdef name="inrouter">
            <timestamp>2011-5-20T15:55:24</timestamp>
            <rect width="432" x="64" y="-512" height="512" />
            <line x2="0" y1="-480" y2="-480" x1="64" />
            <line x2="0" y1="-416" y2="-416" x1="64" />
            <line x2="0" y1="-352" y2="-352" x1="64" />
            <line x2="0" y1="-288" y2="-288" x1="64" />
            <line x2="0" y1="-224" y2="-224" x1="64" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <rect width="64" x="0" y="-108" height="24" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <line x2="560" y1="-480" y2="-480" x1="496" />
            <line x2="560" y1="-416" y2="-416" x1="496" />
            <line x2="560" y1="-352" y2="-352" x1="496" />
            <line x2="560" y1="-288" y2="-288" x1="496" />
            <rect width="64" x="496" y="-236" height="24" />
            <line x2="560" y1="-224" y2="-224" x1="496" />
            <rect width="64" x="496" y="-172" height="24" />
            <line x2="560" y1="-160" y2="-160" x1="496" />
            <rect width="64" x="496" y="-108" height="24" />
            <line x2="560" y1="-96" y2="-96" x1="496" />
        </blockdef>
        <blockdef name="outrouter">
            <timestamp>2011-5-20T15:55:26</timestamp>
            <rect width="448" x="64" y="-512" height="512" />
            <line x2="0" y1="-480" y2="-480" x1="64" />
            <line x2="0" y1="-400" y2="-400" x1="64" />
            <line x2="0" y1="-320" y2="-320" x1="64" />
            <line x2="0" y1="-240" y2="-240" x1="64" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <rect width="64" x="0" y="-92" height="24" />
            <line x2="0" y1="-80" y2="-80" x1="64" />
            <line x2="576" y1="-480" y2="-480" x1="512" />
            <line x2="576" y1="-416" y2="-416" x1="512" />
            <line x2="576" y1="-352" y2="-352" x1="512" />
            <rect width="64" x="512" y="-300" height="24" />
            <line x2="576" y1="-288" y2="-288" x1="512" />
            <rect width="64" x="512" y="-236" height="24" />
            <line x2="576" y1="-224" y2="-224" x1="512" />
            <rect width="64" x="512" y="-172" height="24" />
            <line x2="576" y1="-160" y2="-160" x1="512" />
            <rect width="64" x="512" y="-108" height="24" />
            <line x2="576" y1="-96" y2="-96" x1="512" />
            <rect width="64" x="512" y="-44" height="24" />
            <line x2="576" y1="-32" y2="-32" x1="512" />
        </blockdef>
        <blockdef name="title">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="-796" y1="-288" y2="-256" x1="-764" />
            <line x2="-764" y1="-256" y2="-288" x1="-732" />
            <line x2="-732" y1="-256" y2="-256" x1="-776" />
            <line x2="-776" y1="-264" y2="-256" x1="-788" />
            <line x2="-796" y1="-256" y2="-256" x1="-840" />
            <line x2="-836" y1="-256" y2="-288" x1="-804" />
            <line x2="-832" y1="-256" y2="-288" x1="-800" />
            <line x2="-828" y1="-256" y2="-288" x1="-796" />
            <line x2="-800" y1="-288" y2="-320" x1="-832" />
            <line x2="-796" y1="-288" y2="-320" x1="-828" />
            <line x2="-796" y1="-352" y2="-384" x1="-828" />
            <line x2="-796" y1="-384" y2="-384" x1="-840" />
            <line x2="-764" y1="-384" y2="-352" x1="-796" />
            <line x2="-832" y1="-320" y2="-352" x1="-800" />
            <line x2="-828" y1="-320" y2="-352" x1="-796" />
            <line x2="-836" y1="-320" y2="-352" x1="-804" />
            <line x2="-800" y1="-352" y2="-384" x1="-832" />
            <line x2="-804" y1="-352" y2="-384" x1="-836" />
            <line x2="-840" y1="-352" y2="-384" x1="-872" />
            <line x2="-836" y1="-352" y2="-384" x1="-868" />
            <line x2="-764" y1="-384" y2="-352" x1="-732" />
            <line x2="-732" y1="-384" y2="-384" x1="-776" />
            <line x2="-776" y1="-376" y2="-384" x1="-788" />
            <line x2="-736" y1="-356" y2="-384" x1="-764" />
            <line x2="-740" y1="-360" y2="-384" x1="-768" />
            <line x2="-740" y1="-356" y2="-384" x1="-768" />
            <line x2="-744" y1="-360" y2="-384" x1="-772" />
            <line x2="-748" y1="-360" y2="-384" x1="-772" />
            <line x2="-752" y1="-360" y2="-384" x1="-772" />
            <line x2="-808" y1="-352" y2="-384" x1="-840" />
            <line x2="-812" y1="-352" y2="-384" x1="-844" />
            <line x2="-816" y1="-352" y2="-384" x1="-848" />
            <line x2="-820" y1="-352" y2="-384" x1="-852" />
            <line x2="-848" y1="-256" y2="-288" x1="-816" />
            <line x2="-852" y1="-256" y2="-288" x1="-820" />
            <line x2="-828" y1="-352" y2="-352" x1="-872" />
            <line x2="-868" y1="-320" y2="-352" x1="-836" />
            <line x2="-864" y1="-320" y2="-352" x1="-832" />
            <line x2="-860" y1="-320" y2="-352" x1="-828" />
            <line x2="-856" y1="-320" y2="-352" x1="-824" />
            <line x2="-840" y1="-288" y2="-320" x1="-872" />
            <line x2="-828" y1="-288" y2="-288" x1="-872" />
            <line x2="-828" y1="-352" y2="-384" x1="-860" />
            <line x2="-832" y1="-352" y2="-384" x1="-864" />
            <line x2="-824" y1="-352" y2="-384" x1="-856" />
            <line x2="-824" y1="-288" y2="-320" x1="-856" />
            <line x2="-820" y1="-288" y2="-320" x1="-852" />
            <line x2="-816" y1="-288" y2="-320" x1="-848" />
            <line x2="-812" y1="-288" y2="-320" x1="-844" />
            <line x2="-808" y1="-288" y2="-320" x1="-840" />
            <line x2="-804" y1="-288" y2="-320" x1="-836" />
            <line x2="-836" y1="-288" y2="-320" x1="-868" />
            <line x2="-832" y1="-288" y2="-320" x1="-864" />
            <line x2="-828" y1="-288" y2="-320" x1="-860" />
            <line x2="-872" y1="-320" y2="-352" x1="-840" />
            <line x2="-852" y1="-320" y2="-352" x1="-820" />
            <line x2="-848" y1="-320" y2="-352" x1="-816" />
            <line x2="-844" y1="-320" y2="-352" x1="-812" />
            <line x2="-840" y1="-320" y2="-352" x1="-808" />
            <line x2="-840" y1="-256" y2="-288" x1="-808" />
            <line x2="-844" y1="-256" y2="-288" x1="-812" />
            <line x2="-868" y1="-256" y2="-288" x1="-836" />
            <line x2="-872" y1="-256" y2="-288" x1="-840" />
            <line x2="-856" y1="-256" y2="-288" x1="-824" />
            <line x2="-860" y1="-256" y2="-288" x1="-828" />
            <line x2="-864" y1="-256" y2="-288" x1="-832" />
            <line x2="-756" y1="-364" y2="-384" x1="-772" />
            <line x2="-756" y1="-364" y2="-384" x1="-776" />
            <line x2="-760" y1="-368" y2="-384" x1="-776" />
            <line x2="-764" y1="-368" y2="-384" x1="-780" />
            <line x2="-768" y1="-372" y2="-384" x1="-780" />
            <line x2="-772" y1="-372" y2="-384" x1="-784" />
            <line x2="-772" y1="-376" y2="-384" x1="-784" />
            <line x2="-612" y1="-272" y2="-368" x1="-612" />
            <line x2="-616" y1="-272" y2="-368" x1="-616" />
            <line x2="-620" y1="-272" y2="-368" x1="-620" />
            <line x2="-612" y1="-276" y2="-276" x1="-564" />
            <line x2="-456" y1="-272" y2="-368" x1="-456" />
            <line x2="-460" y1="-272" y2="-368" x1="-460" />
            <line x2="-640" y1="-272" y2="-368" x1="-640" />
            <line x2="-444" y1="-272" y2="-368" x1="-392" />
            <line x2="-444" y1="-368" y2="-272" x1="-392" />
            <line x2="-712" y1="-272" y2="-368" x1="-660" />
            <line x2="-716" y1="-368" y2="-272" x1="-660" />
            <line x2="-544" y1="-272" y2="-368" x1="-544" />
            <line x2="-644" y1="-272" y2="-368" x1="-644" />
            <line x2="-636" y1="-272" y2="-368" x1="-636" />
            <line x2="-708" y1="-272" y2="-368" x1="-656" />
            <line x2="-520" y1="-272" y2="-368" x1="-468" />
            <line x2="-716" y1="-272" y2="-368" x1="-660" />
            <line x2="-720" y1="-272" y2="-368" x1="-664" />
            <line x2="-524" y1="-272" y2="-368" x1="-524" />
            <line x2="-528" y1="-272" y2="-368" x1="-528" />
            <line x2="-632" y1="-272" y2="-368" x1="-632" />
            <line x2="-524" y1="-272" y2="-368" x1="-468" />
            <line x2="-540" y1="-272" y2="-368" x1="-540" />
            <line x2="-516" y1="-272" y2="-368" x1="-464" />
            <line x2="-516" y1="-272" y2="-368" x1="-460" />
            <line x2="-548" y1="-272" y2="-368" x1="-548" />
            <line x2="-440" y1="-272" y2="-368" x1="-388" />
            <line x2="-612" y1="-272" y2="-272" x1="-564" />
            <line x2="-720" y1="-368" y2="-272" x1="-664" />
            <line x2="-784" y1="-256" y2="-264" x1="-772" />
            <line x2="-772" y1="-268" y2="-256" x1="-784" />
            <line x2="-780" y1="-256" y2="-268" x1="-768" />
            <line x2="-764" y1="-272" y2="-256" x1="-780" />
            <line x2="-776" y1="-256" y2="-272" x1="-760" />
            <line x2="-756" y1="-276" y2="-256" x1="-776" />
            <line x2="-772" y1="-256" y2="-276" x1="-756" />
            <line x2="-752" y1="-280" y2="-256" x1="-772" />
            <line x2="-772" y1="-256" y2="-280" x1="-748" />
            <line x2="-744" y1="-280" y2="-256" x1="-772" />
            <line x2="-768" y1="-256" y2="-280" x1="-740" />
            <line x2="-740" y1="-284" y2="-256" x1="-768" />
            <line x2="-764" y1="-256" y2="-284" x1="-736" />
            <line x2="-436" y1="-272" y2="-368" x1="-388" />
            <line x2="-436" y1="-272" y2="-368" x1="-384" />
            <line x2="-440" y1="-368" y2="-272" x1="-388" />
            <line x2="-1140" y1="-176" y2="-176" x1="-112" />
            <line x2="-1136" y1="-416" y2="-212" style="linewidth:W" x1="-1136" />
            <line x2="-80" y1="-416" y2="-220" style="linewidth:W" x1="-80" />
            <line x2="-80" y1="-416" y2="-416" style="linewidth:W" x1="-1136" />
            <line x2="-80" y1="-128" y2="-128" x1="-1136" />
            <line x2="-80" y1="-220" y2="-220" x1="-1132" />
            <line x2="-352" y1="-80" y2="-80" style="linewidth:W" x1="-80" />
            <line x2="-352" y1="-80" y2="-80" style="linewidth:W" x1="-1136" />
            <line x2="-1136" y1="-224" y2="-80" style="linewidth:W" x1="-1136" />
            <line x2="-152" y1="-80" y2="-80" style="linewidth:W" x1="-144" />
            <line x2="-80" y1="-224" y2="-80" style="linewidth:W" x1="-80" />
            <line x2="-80" y1="-176" y2="-176" x1="-112" />
            <line x2="-144" y1="-128" y2="-128" x1="-176" />
            <line x2="-296" y1="-128" y2="-80" x1="-296" />
        </blockdef>
        <blockdef name="config">
            <timestamp>2011-5-20T15:57:1</timestamp>
            <rect width="320" x="64" y="-192" height="192" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <line x2="448" y1="-160" y2="-160" x1="384" />
            <rect width="64" x="384" y="-108" height="24" />
            <line x2="448" y1="-96" y2="-96" x1="384" />
            <rect width="64" x="384" y="-44" height="24" />
            <line x2="448" y1="-32" y2="-32" x1="384" />
        </blockdef>
        <blockdef name="mux16">
            <timestamp>2011-5-20T15:55:51</timestamp>
            <rect width="256" x="64" y="-192" height="192" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <rect width="64" x="0" y="-108" height="24" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <rect width="64" x="320" y="-172" height="24" />
            <line x2="384" y1="-160" y2="-160" x1="320" />
        </blockdef>
        <blockdef name="mux3">
            <timestamp>2011-5-20T15:53:34</timestamp>
            <rect width="256" x="64" y="-192" height="192" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <rect width="64" x="0" y="-108" height="24" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <rect width="64" x="320" y="-172" height="24" />
            <line x2="384" y1="-160" y2="-160" x1="320" />
        </blockdef>
        <blockdef name="and3">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="64" y1="-64" y2="-64" x1="0" />
            <line x2="64" y1="-128" y2="-128" x1="0" />
            <line x2="64" y1="-192" y2="-192" x1="0" />
            <line x2="192" y1="-128" y2="-128" x1="256" />
            <line x2="144" y1="-176" y2="-176" x1="64" />
            <line x2="64" y1="-80" y2="-80" x1="144" />
            <arc ex="144" ey="-176" sx="144" sy="-80" r="48" cx="144" cy="-128" />
            <line x2="64" y1="-64" y2="-192" x1="64" />
        </blockdef>
        <block symbolname="title" name="XLXI_35">
            <attr value="USB Scope" name="TitleFieldText" />
            <attr value="(C) Ali Lown 2010-11" name="NameFieldText" />
        </block>
        <block symbolname="inrouter" name="inst_inrouter">
            <blockpin signalname="CYINT" name="CYINT" />
            <blockpin signalname="MEMCLK" name="CYCLK" />
            <blockpin signalname="RESET" name="MEMCLK" />
            <blockpin signalname="STOP" name="RESET" />
            <blockpin signalname="CYCLK" name="STOP" />
            <blockpin signalname="STATECLK" name="STATE_CLK" />
            <blockpin signalname="CYDATA_IN(15:0)" name="CYDATA_IN(15:0)" />
            <blockpin signalname="MEMDATA_IN(15:0)" name="MEMDATA(15:0)" />
            <blockpin signalname="XLXN_3" name="CYDATA_OUT_SEL" />
            <blockpin signalname="XLXN_77" name="MEMCTRL_SEL" />
            <blockpin signalname="XLXN_85" name="STOPPED" />
            <blockpin signalname="XLXN_193" name="PROCESSINT" />
            <blockpin signalname="XLXN_224(15:0)" name="CYDATA_OUT(15:0)" />
            <blockpin signalname="XLXN_75(2:0)" name="MEMCTRL(2:0)" />
            <blockpin signalname="XLXN_223(63:0)" name="PROCESSDATA(63:0)" />
        </block>
        <block symbolname="config" name="inst_config">
            <blockpin signalname="XLXN_193" name="INT" />
            <blockpin signalname="XLXN_22" name="STOPPED" />
            <blockpin signalname="XLXN_223(63:0)" name="DATA(63:0)" />
            <blockpin signalname="STOP" name="STOP" />
            <blockpin signalname="ADCCLKSEL(2:0)" name="ADCCLKSEL(2:0)" />
            <blockpin signalname="ADCSEL(1:0)" name="ADCSEL(1:0)" />
        </block>
        <block symbolname="mux3" name="inst_mux3">
            <blockpin signalname="XLXN_77" name="SEL" />
            <blockpin signalname="XLXN_75(2:0)" name="D0(2:0)" />
            <blockpin signalname="XLXN_74(2:0)" name="D1(2:0)" />
            <blockpin signalname="MEMCTRL(2:0)" name="D(2:0)" />
        </block>
        <block symbolname="and3" name="inst_stopand">
            <blockpin signalname="XLXN_202" name="I0" />
            <blockpin signalname="STOPPED" name="I1" />
            <blockpin signalname="XLXN_85" name="I2" />
            <blockpin signalname="XLXN_22" name="O" />
        </block>
        <block symbolname="mux16" name="inst_mux16">
            <blockpin signalname="XLXN_3" name="SEL" />
            <blockpin signalname="ADCDATA(15:0)" name="D0(15:0)" />
            <blockpin signalname="XLXN_224(15:0)" name="D1(15:0)" />
            <blockpin signalname="XLXN_1(15:0)" name="D(15:0)" />
        </block>
        <block symbolname="outrouter" name="inst_outrouter">
            <blockpin signalname="ADCCLK" name="ADCCLK" />
            <blockpin signalname="ADCVALID" name="VALID" />
            <blockpin signalname="CYCLK" name="CYCLK" />
            <blockpin signalname="MEMCLK" name="MEMCLK" />
            <blockpin signalname="STOP" name="STOP" />
            <blockpin signalname="XLXN_1(15:0)" name="ADCDATA(15:0)" />
            <blockpin signalname="CYWR_STROBE" name="CYWRITE_STROBE" />
            <blockpin signalname="MEMDONE" name="MEMCTRL_BURST_DONE" />
            <blockpin signalname="XLXN_202" name="STOPPED" />
            <blockpin signalname="CYDATA_OUT(15:0)" name="CYDATA(15:0)" />
            <blockpin signalname="XLXN_74(2:0)" name="MEMCTRL(2:0)" />
            <blockpin signalname="MEMDATAMASK(1:0)" name="MEMDATAMASK(1:0)" />
            <blockpin signalname="MEMDATA_OUT(15:0)" name="MEMDATA(15:0)" />
            <blockpin signalname="MEMADDR(25:0)" name="MEMADDR(25:0)" />
        </block>
    </netlist>
    <sheet sheetnum="1" width="3520" height="2720">
        <instance x="3600" y="2800" name="XLXI_35" orien="R0">
        </instance>
        <branch name="STATECLK">
            <wire x2="1680" y1="944" y2="944" x1="1648" />
        </branch>
        <branch name="CYCLK">
            <wire x2="1680" y1="880" y2="880" x1="1648" />
        </branch>
        <branch name="MEMCLK">
            <wire x2="1680" y1="688" y2="688" x1="1648" />
        </branch>
        <branch name="RESET">
            <wire x2="1680" y1="752" y2="752" x1="1648" />
        </branch>
        <branch name="CYINT">
            <wire x2="1680" y1="624" y2="624" x1="1648" />
        </branch>
        <branch name="MEMDATA_IN(15:0)">
            <wire x2="1680" y1="1072" y2="1072" x1="1648" />
        </branch>
        <branch name="XLXN_22">
            <wire x2="496" y1="1024" y2="1024" x1="464" />
        </branch>
        <iomarker fontsize="28" x="1648" y="944" name="STATECLK" orien="R180" />
        <iomarker fontsize="28" x="1648" y="688" name="MEMCLK" orien="R180" />
        <iomarker fontsize="28" x="1648" y="752" name="RESET" orien="R180" />
        <iomarker fontsize="28" x="1648" y="624" name="CYINT" orien="R180" />
        <iomarker fontsize="28" x="1648" y="1072" name="MEMDATA_IN(15:0)" orien="R180" />
        <branch name="MEMCTRL(2:0)">
            <wire x2="3104" y1="1616" y2="1616" x1="3072" />
        </branch>
        <instance x="2688" y="1776" name="inst_mux3" orien="R0">
        </instance>
        <iomarker fontsize="28" x="3104" y="1616" name="MEMCTRL(2:0)" orien="R0" />
        <branch name="XLXN_75(2:0)">
            <wire x2="2608" y1="944" y2="944" x1="2240" />
            <wire x2="2608" y1="944" y2="1680" x1="2608" />
            <wire x2="2688" y1="1680" y2="1680" x1="2608" />
        </branch>
        <branch name="STOP">
            <wire x2="1232" y1="960" y2="960" x1="944" />
            <wire x2="1232" y1="960" y2="2224" x1="1232" />
            <wire x2="1664" y1="2224" y2="2224" x1="1232" />
            <wire x2="1232" y1="816" y2="816" x1="1120" />
            <wire x2="1680" y1="816" y2="816" x1="1232" />
            <wire x2="1232" y1="816" y2="960" x1="1232" />
        </branch>
        <iomarker fontsize="28" x="1648" y="880" name="CYCLK" orien="R180" />
        <instance x="208" y="1152" name="inst_stopand" orien="R0" />
        <branch name="STOPPED">
            <wire x2="208" y1="1024" y2="1024" x1="176" />
        </branch>
        <iomarker fontsize="28" x="176" y="1024" name="STOPPED" orien="R180" />
        <branch name="XLXN_85">
            <wire x2="208" y1="432" y2="960" x1="208" />
            <wire x2="2304" y1="432" y2="432" x1="208" />
            <wire x2="2304" y1="432" y2="752" x1="2304" />
            <wire x2="2304" y1="752" y2="752" x1="2240" />
        </branch>
        <branch name="CYDATA_IN(15:0)">
            <wire x2="1680" y1="1008" y2="1008" x1="1648" />
        </branch>
        <iomarker fontsize="28" x="1648" y="1008" name="CYDATA_IN(15:0)" orien="R180" />
        <iomarker fontsize="28" x="1120" y="816" name="STOP" orien="R180" />
        <branch name="MEMADDR(25:0)">
            <wire x2="2272" y1="2352" y2="2352" x1="2240" />
        </branch>
        <branch name="MEMDATAMASK(1:0)">
            <wire x2="2272" y1="2224" y2="2224" x1="2240" />
        </branch>
        <branch name="MEMDATA_OUT(15:0)">
            <wire x2="2272" y1="2288" y2="2288" x1="2240" />
        </branch>
        <branch name="CYDATA_OUT(15:0)">
            <wire x2="2272" y1="2096" y2="2096" x1="2240" />
        </branch>
        <iomarker fontsize="28" x="1632" y="1904" name="ADCCLK" orien="R180" />
        <iomarker fontsize="28" x="2272" y="2352" name="MEMADDR(25:0)" orien="R0" />
        <iomarker fontsize="28" x="2272" y="2288" name="MEMDATA_OUT(15:0)" orien="R0" />
        <iomarker fontsize="28" x="2272" y="2224" name="MEMDATAMASK(1:0)" orien="R0" />
        <iomarker fontsize="28" x="2272" y="2096" name="CYDATA_OUT(15:0)" orien="R0" />
        <branch name="XLXN_77">
            <wire x2="2688" y1="688" y2="688" x1="2240" />
            <wire x2="2688" y1="688" y2="1616" x1="2688" />
        </branch>
        <instance x="1680" y="1104" name="inst_inrouter" orien="R0">
        </instance>
        <branch name="ADCDATA(15:0)">
            <wire x2="1120" y1="2368" y2="2368" x1="1104" />
        </branch>
        <instance x="496" y="1120" name="inst_config" orien="R0">
        </instance>
        <branch name="ADCCLKSEL(2:0)">
            <wire x2="960" y1="1024" y2="1024" x1="944" />
        </branch>
        <iomarker fontsize="28" x="960" y="1024" name="ADCCLKSEL(2:0)" orien="R0" />
        <branch name="ADCSEL(1:0)">
            <wire x2="960" y1="1088" y2="1088" x1="944" />
        </branch>
        <iomarker fontsize="28" x="960" y="1088" name="ADCSEL(1:0)" orien="R0" />
        <branch name="XLXN_74(2:0)">
            <wire x2="2672" y1="2160" y2="2160" x1="2240" />
            <wire x2="2688" y1="1744" y2="1744" x1="2672" />
            <wire x2="2672" y1="1744" y2="2160" x1="2672" />
        </branch>
        <branch name="ADCCLK">
            <wire x2="1664" y1="1904" y2="1904" x1="1632" />
        </branch>
        <branch name="XLXN_202">
            <wire x2="208" y1="1088" y2="1088" x1="192" />
            <wire x2="192" y1="1088" y2="1760" x1="192" />
            <wire x2="2512" y1="1760" y2="1760" x1="192" />
            <wire x2="2512" y1="1760" y2="2032" x1="2512" />
            <wire x2="2512" y1="2032" y2="2032" x1="2240" />
        </branch>
        <instance x="1664" y="2384" name="inst_outrouter" orien="R0">
        </instance>
        <branch name="MEMCLK">
            <attrtext style="alignment:SOFT-RIGHT" attrname="Name" x="1632" y="2144" type="branch" />
            <wire x2="1664" y1="2144" y2="2144" x1="1632" />
        </branch>
        <branch name="CYCLK">
            <attrtext style="alignment:SOFT-RIGHT" attrname="Name" x="1632" y="2064" type="branch" />
            <wire x2="1664" y1="2064" y2="2064" x1="1632" />
        </branch>
        <instance x="1120" y="2464" name="inst_mux16" orien="R0">
        </instance>
        <branch name="XLXN_3">
            <wire x2="1040" y1="1264" y2="2304" x1="1040" />
            <wire x2="1120" y1="2304" y2="2304" x1="1040" />
            <wire x2="2256" y1="1264" y2="1264" x1="1040" />
            <wire x2="2256" y1="624" y2="624" x1="2240" />
            <wire x2="2256" y1="624" y2="1264" x1="2256" />
        </branch>
        <branch name="XLXN_1(15:0)">
            <wire x2="1664" y1="2304" y2="2304" x1="1504" />
        </branch>
        <branch name="ADCVALID">
            <wire x2="1664" y1="1984" y2="1984" x1="1632" />
        </branch>
        <iomarker fontsize="28" x="1632" y="1984" name="ADCVALID" orien="R180" />
        <iomarker fontsize="28" x="1104" y="2368" name="ADCDATA(15:0)" orien="R180" />
        <branch name="XLXN_193">
            <wire x2="496" y1="960" y2="960" x1="448" />
            <wire x2="448" y1="960" y2="1504" x1="448" />
            <wire x2="2288" y1="1504" y2="1504" x1="448" />
            <wire x2="2288" y1="816" y2="816" x1="2240" />
            <wire x2="2288" y1="816" y2="1504" x1="2288" />
        </branch>
        <branch name="CYWR_STROBE">
            <wire x2="2272" y1="1904" y2="1904" x1="2240" />
        </branch>
        <iomarker fontsize="28" x="2272" y="1904" name="CYWR_STROBE" orien="R0" />
        <branch name="MEMDONE">
            <wire x2="2272" y1="1968" y2="1968" x1="2240" />
        </branch>
        <iomarker fontsize="28" x="2272" y="1968" name="MEMDONE" orien="R0" />
        <branch name="XLXN_223(63:0)">
            <wire x2="496" y1="1088" y2="1088" x1="464" />
            <wire x2="464" y1="1088" y2="1168" x1="464" />
            <wire x2="2272" y1="1168" y2="1168" x1="464" />
            <wire x2="2272" y1="1008" y2="1008" x1="2240" />
            <wire x2="2272" y1="1008" y2="1168" x1="2272" />
        </branch>
        <branch name="XLXN_224(15:0)">
            <wire x2="832" y1="1216" y2="2432" x1="832" />
            <wire x2="1120" y1="2432" y2="2432" x1="832" />
            <wire x2="2320" y1="1216" y2="1216" x1="832" />
            <wire x2="2320" y1="880" y2="880" x1="2240" />
            <wire x2="2320" y1="880" y2="1216" x1="2320" />
        </branch>
    </sheet>
</drawing>