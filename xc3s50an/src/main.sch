<?xml version="1.0" encoding="UTF-8"?>
<drawing version="7">
    <attr value="spartan3a" name="DeviceFamilyName">
        <trait delete="all:0" />
        <trait editname="all:0" />
        <trait edittrait="all:0" />
    </attr>
    <netlist>
        <signal name="UARTCLK" />
        <signal name="POR" />
        <signal name="DDRCLK" />
        <signal name="DCMLCK" />
        <signal name="DDRCLKx2" />
        <signal name="SINA" />
        <signal name="SOUTA" />
        <signal name="SINB" />
        <signal name="SOUTB" />
        <signal name="XLXN_551" />
        <signal name="XLXN_552" />
        <signal name="XLXN_559" />
        <signal name="MCLK" />
        <signal name="XLXN_449" />
        <signal name="CYSLRD" />
        <signal name="CYSLOE" />
        <signal name="CYSLWR" />
        <signal name="CYPKTEND" />
        <signal name="CYFD(15:0)" />
        <signal name="CYFIFOADDR(1:0)" />
        <signal name="CYFLAGC" />
        <signal name="CYFLAGB" />
        <signal name="CYFLAGA" />
        <signal name="CYCLK" />
        <signal name="XLXN_675" />
        <signal name="XLXN_676(15:0)" />
        <signal name="XLXN_679" />
        <signal name="XLXN_680(15:0)" />
        <signal name="ADCD1(7:0)" />
        <signal name="ADCD0(7:0)" />
        <signal name="XLXN_292" />
        <signal name="ADCOE" />
        <signal name="ADCPD" />
        <signal name="ADCCLK" />
        <signal name="XLXN_688(2:0)" />
        <signal name="XLXN_689(1:0)" />
        <signal name="XLXN_690(15:0)" />
        <signal name="XLXN_691" />
        <signal name="XLXN_751" />
        <signal name="XLXN_754" />
        <signal name="XLXN_755" />
        <signal name="CLKADC" />
        <signal name="DDRCLK90" />
        <port polarity="Input" name="SINA" />
        <port polarity="Output" name="SOUTA" />
        <port polarity="Input" name="SINB" />
        <port polarity="Output" name="SOUTB" />
        <port polarity="Input" name="MCLK" />
        <port polarity="Output" name="CYSLRD" />
        <port polarity="Output" name="CYSLOE" />
        <port polarity="Output" name="CYSLWR" />
        <port polarity="Output" name="CYPKTEND" />
        <port polarity="BiDirectional" name="CYFD(15:0)" />
        <port polarity="Output" name="CYFIFOADDR(1:0)" />
        <port polarity="Input" name="CYFLAGC" />
        <port polarity="Input" name="CYFLAGB" />
        <port polarity="Input" name="CYFLAGA" />
        <port polarity="Input" name="CYCLK" />
        <port polarity="Input" name="ADCD1(7:0)" />
        <port polarity="Input" name="ADCD0(7:0)" />
        <port polarity="Output" name="ADCOE" />
        <port polarity="Output" name="ADCPD" />
        <port polarity="Output" name="ADCCLK" />
        <blockdef name="sampleclk">
            <timestamp>2011-5-20T15:51:52</timestamp>
            <rect width="256" x="64" y="-128" height="128" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <line x2="384" y1="-96" y2="-96" x1="320" />
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
        <blockdef name="adcmgr">
            <timestamp>2011-5-20T15:52:40</timestamp>
            <rect width="256" x="64" y="-320" height="320" />
            <line x2="0" y1="-288" y2="-288" x1="64" />
            <line x2="0" y1="-224" y2="-224" x1="64" />
            <rect width="64" x="0" y="-172" height="24" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <rect width="64" x="0" y="-108" height="24" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <line x2="384" y1="-288" y2="-288" x1="320" />
            <line x2="384" y1="-224" y2="-224" x1="320" />
            <line x2="384" y1="-160" y2="-160" x1="320" />
            <line x2="384" y1="-96" y2="-96" x1="320" />
            <rect width="64" x="320" y="-44" height="24" />
            <line x2="384" y1="-32" y2="-32" x1="320" />
        </blockdef>
        <blockdef name="and2">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="64" y1="-64" y2="-64" x1="0" />
            <line x2="64" y1="-128" y2="-128" x1="0" />
            <line x2="192" y1="-96" y2="-96" x1="256" />
            <arc ex="144" ey="-144" sx="144" sy="-48" r="48" cx="144" cy="-96" />
            <line x2="64" y1="-48" y2="-48" x1="144" />
            <line x2="144" y1="-144" y2="-144" x1="64" />
            <line x2="64" y1="-48" y2="-144" x1="64" />
        </blockdef>
        <blockdef name="cyfifo">
            <timestamp>2011-5-20T15:52:1</timestamp>
            <rect width="496" x="64" y="-512" height="512" />
            <line x2="0" y1="-480" y2="-480" x1="64" />
            <line x2="0" y1="-416" y2="-416" x1="64" />
            <line x2="0" y1="-352" y2="-352" x1="64" />
            <line x2="0" y1="-288" y2="-288" x1="64" />
            <line x2="0" y1="-224" y2="-224" x1="64" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <line x2="624" y1="-480" y2="-480" x1="560" />
            <line x2="624" y1="-416" y2="-416" x1="560" />
            <line x2="624" y1="-352" y2="-352" x1="560" />
            <line x2="624" y1="-288" y2="-288" x1="560" />
            <line x2="624" y1="-224" y2="-224" x1="560" />
            <rect width="64" x="560" y="-172" height="24" />
            <line x2="624" y1="-160" y2="-160" x1="560" />
            <rect width="64" x="560" y="-108" height="24" />
            <line x2="624" y1="-96" y2="-96" x1="560" />
            <rect width="64" x="560" y="-44" height="24" />
            <line x2="624" y1="-32" y2="-32" x1="560" />
        </blockdef>
        <blockdef name="uart_16750">
            <timestamp>2011-5-20T15:52:4</timestamp>
            <rect width="256" x="64" y="-896" height="896" />
            <line x2="0" y1="-864" y2="-864" x1="64" />
            <line x2="0" y1="-800" y2="-800" x1="64" />
            <line x2="0" y1="-736" y2="-736" x1="64" />
            <line x2="0" y1="-672" y2="-672" x1="64" />
            <line x2="0" y1="-608" y2="-608" x1="64" />
            <line x2="0" y1="-544" y2="-544" x1="64" />
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
            <line x2="384" y1="-864" y2="-864" x1="320" />
            <line x2="384" y1="-768" y2="-768" x1="320" />
            <line x2="384" y1="-672" y2="-672" x1="320" />
            <line x2="384" y1="-576" y2="-576" x1="320" />
            <line x2="384" y1="-480" y2="-480" x1="320" />
            <line x2="384" y1="-384" y2="-384" x1="320" />
            <line x2="384" y1="-288" y2="-288" x1="320" />
            <line x2="384" y1="-192" y2="-192" x1="320" />
            <rect width="64" x="320" y="-108" height="24" />
            <line x2="384" y1="-96" y2="-96" x1="320" />
        </blockdef>
        <blockdef name="div10">
            <timestamp>2011-5-20T15:52:7</timestamp>
            <rect width="256" x="64" y="-64" height="64" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <line x2="384" y1="-32" y2="-32" x1="320" />
        </blockdef>
        <blockdef name="vcc">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="64" y1="-32" y2="-64" x1="64" />
            <line x2="64" y1="0" y2="-32" x1="64" />
            <line x2="32" y1="-64" y2="-64" x1="96" />
        </blockdef>
        <blockdef name="dcm">
            <timestamp>2011-5-20T16:52:33</timestamp>
            <rect width="336" x="64" y="-256" height="256" />
            <line x2="0" y1="-224" y2="-224" x1="64" />
            <line x2="464" y1="-224" y2="-224" x1="400" />
            <line x2="464" y1="-160" y2="-160" x1="400" />
            <line x2="464" y1="-96" y2="-96" x1="400" />
            <line x2="464" y1="-32" y2="-32" x1="400" />
        </blockdef>
        <blockdef name="memdcm">
            <timestamp>2011-5-20T16:54:3</timestamp>
            <rect width="256" x="64" y="-320" height="320" />
            <line x2="0" y1="-288" y2="-288" x1="64" />
            <line x2="384" y1="-288" y2="-288" x1="320" />
            <line x2="384" y1="-224" y2="-224" x1="320" />
            <line x2="384" y1="-160" y2="-160" x1="320" />
            <line x2="384" y1="-96" y2="-96" x1="320" />
            <line x2="384" y1="-32" y2="-32" x1="320" />
        </blockdef>
        <blockdef name="processor">
            <timestamp>2011-5-20T16:24:41</timestamp>
            <rect width="896" x="-448" y="-448" height="896" />
            <line x2="-512" y1="96" y2="96" x1="-448" />
            <line x2="-512" y1="192" y2="192" x1="-448" />
            <line x2="512" y1="96" y2="96" x1="448" />
            <rect width="64" x="448" y="84" height="24" />
            <line x2="-512" y1="288" y2="288" x1="-448" />
            <line x2="512" y1="-192" y2="-192" x1="448" />
            <rect width="64" x="448" y="-204" height="24" />
            <line x2="512" y1="-96" y2="-96" x1="448" />
            <rect width="64" x="448" y="-108" height="24" />
            <line x2="512" y1="192" y2="192" x1="448" />
            <rect width="64" x="448" y="180" height="24" />
            <line x2="512" y1="0" y2="0" x1="448" />
            <rect width="64" x="448" y="-12" height="24" />
            <line x2="512" y1="-288" y2="-288" x1="448" />
            <line x2="-512" y1="-288" y2="-288" x1="-448" />
            <line x2="-512" y1="-192" y2="-192" x1="-448" />
            <line x2="-512" y1="-96" y2="-96" x1="-448" />
            <line x2="-512" y1="0" y2="0" x1="-448" />
            <line x2="-32" y1="448" y2="512" x1="-32" />
            <line x2="-112" y1="448" y2="512" x1="-112" />
            <rect width="24" x="-124" y="448" height="64" />
            <line x2="-144" y1="-448" y2="-512" x1="-144" />
            <rect width="24" x="-156" y="-512" height="64" />
            <line x2="48" y1="-448" y2="-512" x1="48" />
            <rect width="24" x="36" y="-512" height="64" />
            <line x2="-48" y1="-448" y2="-512" x1="-48" />
            <rect width="24" x="-60" y="-512" height="64" />
            <line x2="144" y1="-448" y2="-512" x1="144" />
            <line x2="32" y1="448" y2="512" x1="32" />
            <line x2="112" y1="448" y2="512" x1="112" />
            <rect width="24" x="100" y="448" height="64" />
        </blockdef>
        <block symbolname="title" name="XLXI_35">
            <attr value="USB Scope" name="TitleFieldText" />
            <attr value="(C) Ali Lown 2010-11" name="NameFieldText" />
        </block>
        <block symbolname="title" name="XLXI_86">
            <attr value="USB Scope" name="TitleFieldText" />
            <attr value="(C) Ali Lown 2010" name="NameFieldText" />
        </block>
        <block symbolname="title" name="XLXI_106">
            <attr value="USB Scope" name="TitleFieldText" />
            <attr value="(C) Ali Lown 2010" name="NameFieldText" />
        </block>
        <block symbolname="uart_16750" name="inst_uart0">
            <blockpin signalname="UARTCLK" name="CLK" />
            <blockpin signalname="POR" name="RST" />
            <blockpin signalname="XLXN_559" name="BAUDCE" />
            <blockpin name="CS" />
            <blockpin name="WR" />
            <blockpin name="RD" />
            <blockpin signalname="XLXN_551" name="RCLK" />
            <blockpin name="CTSN" />
            <blockpin name="DSRN" />
            <blockpin name="DCDN" />
            <blockpin name="RIN" />
            <blockpin signalname="SINA" name="SIN" />
            <blockpin name="A(2:0)" />
            <blockpin name="DIN(7:0)" />
            <blockpin name="DDIS" />
            <blockpin name="INT" />
            <blockpin name="OUT1N" />
            <blockpin name="OUT2N" />
            <blockpin signalname="XLXN_551" name="BAUDOUTN" />
            <blockpin name="RTSN" />
            <blockpin name="DTRN" />
            <blockpin signalname="SOUTA" name="SOUT" />
            <blockpin name="DOUT(7:0)" />
        </block>
        <block symbolname="uart_16750" name="inst_uart1">
            <blockpin signalname="UARTCLK" name="CLK" />
            <blockpin signalname="POR" name="RST" />
            <blockpin signalname="XLXN_559" name="BAUDCE" />
            <blockpin name="CS" />
            <blockpin name="WR" />
            <blockpin name="RD" />
            <blockpin signalname="XLXN_552" name="RCLK" />
            <blockpin name="CTSN" />
            <blockpin name="DSRN" />
            <blockpin name="DCDN" />
            <blockpin name="RIN" />
            <blockpin signalname="SINB" name="SIN" />
            <blockpin name="A(2:0)" />
            <blockpin name="DIN(7:0)" />
            <blockpin name="DDIS" />
            <blockpin name="INT" />
            <blockpin name="OUT1N" />
            <blockpin name="OUT2N" />
            <blockpin signalname="XLXN_552" name="BAUDOUTN" />
            <blockpin name="RTSN" />
            <blockpin name="DTRN" />
            <blockpin signalname="SOUTB" name="SOUT" />
            <blockpin name="DOUT(7:0)" />
        </block>
        <block symbolname="vcc" name="XLXI_193">
            <blockpin signalname="XLXN_559" name="P" />
        </block>
        <block symbolname="and2" name="inst_dcmand">
            <blockpin signalname="XLXN_449" name="I0" />
            <blockpin signalname="XLXN_754" name="I1" />
            <blockpin signalname="DCMLCK" name="O" />
        </block>
        <block symbolname="div10" name="inst_div10">
            <blockpin signalname="CLKADC" name="CLKIN" />
            <blockpin signalname="UARTCLK" name="CLKOUT" />
        </block>
        <block symbolname="dcm" name="inst_dcm0">
            <blockpin signalname="MCLK" name="CLKIN_IN" />
            <blockpin signalname="XLXN_754" name="LOCKED_OUT" />
            <blockpin signalname="XLXN_755" name="CLKFX_OUT" />
            <blockpin name="CLKIN_IBUFG_OUT" />
            <blockpin name="CLK0_OUT" />
        </block>
        <block symbolname="memdcm" name="inst_dcm1">
            <blockpin signalname="XLXN_755" name="CLKIN_IN" />
            <blockpin signalname="XLXN_449" name="LOCKED_OUT" />
            <blockpin signalname="DDRCLK90" name="CLK90_OUT" />
            <blockpin signalname="DDRCLKx2" name="CLK2X_OUT" />
            <blockpin signalname="CLKADC" name="CLKFX_OUT" />
            <blockpin signalname="DDRCLK" name="CLK0_OUT" />
        </block>
        <block symbolname="processor" name="XLXI_199">
            <blockpin signalname="ADCCLK" name="ADCCLK" />
            <blockpin signalname="CYCLK" name="CYCLK" />
            <blockpin name="MEMADDR(25:0)" />
            <blockpin signalname="DDRCLK" name="MEMCLK" />
            <blockpin name="MEMCTRL(2:0)" />
            <blockpin name="MEMDATAMASK(1:0)" />
            <blockpin name="MEMDATA_IN(15:0)" />
            <blockpin name="MEMDATA_OUT(15:0)" />
            <blockpin name="MEMDONE" />
            <blockpin signalname="POR" name="RESET" />
            <blockpin signalname="DDRCLKx2" name="STATECLK" />
            <blockpin signalname="XLXN_751" name="STOP" />
            <blockpin name="STOPPED" />
            <blockpin signalname="XLXN_675" name="CYWR_STROBE" />
            <blockpin signalname="XLXN_676(15:0)" name="CYDATA_OUT(15:0)" />
            <blockpin signalname="XLXN_688(2:0)" name="ADCCLKSEL(2:0)" />
            <blockpin signalname="XLXN_690(15:0)" name="ADCDATA(15:0)" />
            <blockpin signalname="XLXN_689(1:0)" name="ADCSEL(1:0)" />
            <blockpin signalname="XLXN_691" name="ADCVALID" />
            <blockpin signalname="XLXN_679" name="CYINT" />
            <blockpin signalname="XLXN_680(15:0)" name="CYDATA_IN(15:0)" />
        </block>
        <block symbolname="cyfifo" name="inst_cypress">
            <blockpin signalname="POR" name="RESET" />
            <blockpin signalname="XLXN_675" name="WRITE_STROBE" />
            <blockpin signalname="CYCLK" name="CLKIN" />
            <blockpin signalname="DDRCLK" name="STATE_CLK" />
            <blockpin signalname="CYFLAGA" name="CY_FLAGA" />
            <blockpin signalname="CYFLAGB" name="CY_FLAGB" />
            <blockpin signalname="CYFLAGC" name="CY_FLAGC" />
            <blockpin signalname="XLXN_676(15:0)" name="USER_IN_DATA(15:0)" />
            <blockpin signalname="XLXN_679" name="DATAINT" />
            <blockpin signalname="CYSLRD" name="CY_SLRD" />
            <blockpin signalname="CYSLWR" name="CY_SLWR" />
            <blockpin signalname="CYSLOE" name="CY_SLOE" />
            <blockpin signalname="CYPKTEND" name="CY_PKTEND" />
            <blockpin signalname="XLXN_680(15:0)" name="USER_OUT_DATA(15:0)" />
            <blockpin signalname="CYFIFOADDR(1:0)" name="CY_FIFOADDR(1:0)" />
            <blockpin signalname="CYFD(15:0)" name="CY_FD(15:0)" />
        </block>
        <block symbolname="sampleclk" name="inst_sampleclk">
            <blockpin signalname="ADCCLK" name="CLKIN" />
            <blockpin signalname="XLXN_688(2:0)" name="sel(2:0)" />
            <blockpin signalname="XLXN_292" name="CLK" />
        </block>
        <block symbolname="adcmgr" name="inst_adcmgr">
            <blockpin signalname="XLXN_292" name="SMPLCLK" />
            <blockpin signalname="XLXN_751" name="ZZ" />
            <blockpin signalname="ADCD0(7:0)" name="D0(7:0)" />
            <blockpin signalname="ADCD1(7:0)" name="D1(7:0)" />
            <blockpin signalname="XLXN_689(1:0)" name="SEL(1:0)" />
            <blockpin signalname="ADCCLK" name="CLK" />
            <blockpin signalname="ADCOE" name="OE" />
            <blockpin signalname="ADCPD" name="PD" />
            <blockpin signalname="XLXN_691" name="VALID" />
            <blockpin signalname="XLXN_690(15:0)" name="DATA(15:0)" />
        </block>
    </netlist>
    <sheet sheetnum="1" width="3801" height="2688">
        <attr value="CM" name="LengthUnitName" />
        <attr value="4" name="GridsPerUnit" />
        <instance x="3872" y="2768" name="XLXI_35" orien="R0">
        </instance>
        <instance x="1088" y="1264" name="XLXI_199" orien="R0">
        </instance>
        <branch name="CYSLRD">
            <wire x2="1328" y1="2160" y2="2160" x1="1296" />
        </branch>
        <branch name="CYSLOE">
            <wire x2="1328" y1="2288" y2="2288" x1="1296" />
        </branch>
        <branch name="CYSLWR">
            <wire x2="1328" y1="2224" y2="2224" x1="1296" />
        </branch>
        <branch name="CYPKTEND">
            <wire x2="1328" y1="2352" y2="2352" x1="1296" />
        </branch>
        <branch name="CYFD(15:0)">
            <wire x2="1328" y1="2544" y2="2544" x1="1296" />
        </branch>
        <branch name="CYFIFOADDR(1:0)">
            <wire x2="1344" y1="2480" y2="2480" x1="1296" />
        </branch>
        <branch name="CYFLAGC">
            <wire x2="672" y1="2480" y2="2480" x1="656" />
        </branch>
        <branch name="CYFLAGB">
            <wire x2="672" y1="2416" y2="2416" x1="656" />
        </branch>
        <branch name="CYFLAGA">
            <wire x2="672" y1="2352" y2="2352" x1="656" />
        </branch>
        <branch name="DDRCLK">
            <attrtext style="alignment:SOFT-RIGHT" attrname="Name" x="640" y="2288" type="branch" />
            <wire x2="672" y1="2288" y2="2288" x1="640" />
        </branch>
        <branch name="CYCLK">
            <attrtext style="alignment:SOFT-BCENTER" attrname="Name" x="640" y="2224" type="branch" />
            <wire x2="672" y1="2224" y2="2224" x1="640" />
            <wire x2="640" y1="2224" y2="2608" x1="640" />
            <wire x2="1328" y1="2608" y2="2608" x1="640" />
        </branch>
        <branch name="POR">
            <attrtext style="alignment:SOFT-RIGHT" attrname="Name" x="640" y="2096" type="branch" />
            <wire x2="672" y1="2096" y2="2096" x1="640" />
        </branch>
        <instance x="672" y="2576" name="inst_cypress" orien="R0">
        </instance>
        <branch name="XLXN_675">
            <wire x2="544" y1="1840" y2="2160" x1="544" />
            <wire x2="672" y1="2160" y2="2160" x1="544" />
            <wire x2="1056" y1="1840" y2="1840" x1="544" />
            <wire x2="1056" y1="1776" y2="1840" x1="1056" />
        </branch>
        <branch name="XLXN_676(15:0)">
            <wire x2="976" y1="1824" y2="1824" x1="448" />
            <wire x2="448" y1="1824" y2="2544" x1="448" />
            <wire x2="672" y1="2544" y2="2544" x1="448" />
            <wire x2="976" y1="1776" y2="1824" x1="976" />
        </branch>
        <branch name="XLXN_679">
            <wire x2="1120" y1="1776" y2="1840" x1="1120" />
            <wire x2="1360" y1="1840" y2="1840" x1="1120" />
            <wire x2="1360" y1="1840" y2="2096" x1="1360" />
            <wire x2="1360" y1="2096" y2="2096" x1="1296" />
        </branch>
        <branch name="XLXN_680(15:0)">
            <wire x2="1200" y1="1776" y2="1824" x1="1200" />
            <wire x2="1536" y1="1824" y2="1824" x1="1200" />
            <wire x2="1536" y1="1824" y2="2416" x1="1536" />
            <wire x2="1536" y1="2416" y2="2416" x1="1296" />
        </branch>
        <branch name="ADCCLK">
            <attrtext style="alignment:SOFT-RIGHT" attrname="Name" x="544" y="192" type="branch" />
            <wire x2="576" y1="192" y2="192" x1="544" />
        </branch>
        <branch name="ADCD1(7:0)">
            <wire x2="1200" y1="384" y2="384" x1="1168" />
        </branch>
        <branch name="ADCD0(7:0)">
            <wire x2="1200" y1="320" y2="320" x1="1168" />
        </branch>
        <branch name="XLXN_292">
            <wire x2="1200" y1="192" y2="192" x1="960" />
        </branch>
        <instance x="576" y="288" name="inst_sampleclk" orien="R0">
        </instance>
        <instance x="1200" y="480" name="inst_adcmgr" orien="R0">
        </instance>
        <branch name="ADCOE">
            <wire x2="1616" y1="256" y2="256" x1="1584" />
        </branch>
        <branch name="ADCPD">
            <wire x2="1616" y1="320" y2="320" x1="1584" />
        </branch>
        <branch name="ADCCLK">
            <wire x2="1616" y1="192" y2="192" x1="1584" />
        </branch>
        <branch name="XLXN_688(2:0)">
            <wire x2="576" y1="256" y2="256" x1="512" />
            <wire x2="512" y1="256" y2="704" x1="512" />
            <wire x2="944" y1="704" y2="704" x1="512" />
            <wire x2="944" y1="704" y2="752" x1="944" />
        </branch>
        <branch name="XLXN_689(1:0)">
            <wire x2="1200" y1="448" y2="448" x1="1040" />
            <wire x2="1040" y1="448" y2="752" x1="1040" />
        </branch>
        <branch name="XLXN_690(15:0)">
            <wire x2="1136" y1="688" y2="752" x1="1136" />
            <wire x2="1616" y1="688" y2="688" x1="1136" />
            <wire x2="1616" y1="448" y2="448" x1="1584" />
            <wire x2="1616" y1="448" y2="688" x1="1616" />
        </branch>
        <branch name="XLXN_691">
            <wire x2="1232" y1="720" y2="752" x1="1232" />
            <wire x2="1648" y1="720" y2="720" x1="1232" />
            <wire x2="1648" y1="384" y2="384" x1="1584" />
            <wire x2="1648" y1="384" y2="720" x1="1648" />
        </branch>
        <iomarker fontsize="28" x="1328" y="2160" name="CYSLRD" orien="R0" />
        <iomarker fontsize="28" x="1328" y="2224" name="CYSLWR" orien="R0" />
        <iomarker fontsize="28" x="1328" y="2288" name="CYSLOE" orien="R0" />
        <iomarker fontsize="28" x="1328" y="2352" name="CYPKTEND" orien="R0" />
        <iomarker fontsize="28" x="1328" y="2544" name="CYFD(15:0)" orien="R0" />
        <iomarker fontsize="28" x="1344" y="2480" name="CYFIFOADDR(1:0)" orien="R0" />
        <iomarker fontsize="28" x="656" y="2480" name="CYFLAGC" orien="R180" />
        <iomarker fontsize="28" x="656" y="2416" name="CYFLAGB" orien="R180" />
        <iomarker fontsize="28" x="656" y="2352" name="CYFLAGA" orien="R180" />
        <iomarker fontsize="28" x="1168" y="384" name="ADCD1(7:0)" orien="R180" />
        <iomarker fontsize="28" x="1168" y="320" name="ADCD0(7:0)" orien="R180" />
        <iomarker fontsize="28" x="1616" y="192" name="ADCCLK" orien="R0" />
        <iomarker fontsize="28" x="1616" y="256" name="ADCOE" orien="R0" />
        <iomarker fontsize="28" x="1616" y="320" name="ADCPD" orien="R0" />
        <branch name="ADCCLK">
            <attrtext style="alignment:SOFT-RIGHT" attrname="Name" x="544" y="1360" type="branch" />
            <wire x2="576" y1="1360" y2="1360" x1="544" />
        </branch>
        <branch name="CYCLK">
            <attrtext style="alignment:SOFT-RIGHT" attrname="Name" x="544" y="1456" type="branch" />
            <wire x2="576" y1="1456" y2="1456" x1="544" />
        </branch>
        <branch name="DDRCLK">
            <attrtext style="alignment:SOFT-RIGHT" attrname="Name" x="544" y="1552" type="branch" />
            <wire x2="576" y1="1552" y2="1552" x1="544" />
        </branch>
        <branch name="DDRCLKx2">
            <attrtext style="alignment:SOFT-RIGHT" attrname="Name" x="544" y="1072" type="branch" />
            <wire x2="576" y1="1072" y2="1072" x1="544" />
        </branch>
        <branch name="POR">
            <attrtext style="alignment:SOFT-RIGHT" attrname="Name" x="544" y="976" type="branch" />
            <wire x2="576" y1="976" y2="976" x1="544" />
        </branch>
        <branch name="XLXN_751">
            <wire x2="352" y1="304" y2="1168" x1="352" />
            <wire x2="576" y1="1168" y2="1168" x1="352" />
            <wire x2="928" y1="304" y2="304" x1="352" />
            <wire x2="960" y1="304" y2="304" x1="928" />
            <wire x2="1200" y1="256" y2="256" x1="960" />
            <wire x2="960" y1="256" y2="304" x1="960" />
        </branch>
        <iomarker fontsize="28" x="1328" y="2608" name="CYCLK" orien="R0" />
    </sheet>
    <sheet sheetnum="2" width="2688" height="1900">
        <attr value="CM" name="LengthUnitName" />
        <attr value="4" name="GridsPerUnit" />
        <instance x="2752" y="1968" name="XLXI_86" orien="R0">
        </instance>
        <instance x="1712" y="560" name="inst_dcmand" orien="R0" />
        <branch name="DCMLCK">
            <attrtext style="alignment:SOFT-LEFT" attrname="Name" x="2000" y="464" type="branch" />
            <wire x2="2000" y1="464" y2="464" x1="1968" />
        </branch>
        <branch name="XLXN_449">
            <wire x2="1712" y1="496" y2="496" x1="1696" />
            <wire x2="1696" y1="496" y2="624" x1="1696" />
        </branch>
        <instance x="1888" y="848" name="inst_div10" orien="R0">
        </instance>
        <branch name="UARTCLK">
            <attrtext style="alignment:SOFT-LEFT" attrname="Name" x="2304" y="816" type="branch" />
            <wire x2="2304" y1="816" y2="816" x1="2272" />
        </branch>
        <text x="2214" y="808">20</text>
        <instance x="448" y="688" name="inst_dcm0" orien="R0">
        </instance>
        <instance x="1312" y="912" name="inst_dcm1" orien="R0">
        </instance>
        <iomarker fontsize="28" x="416" y="464" name="MCLK" orien="R180" />
        <branch name="MCLK">
            <wire x2="448" y1="464" y2="464" x1="416" />
        </branch>
        <text x="430" y="440">33.3333</text>
        <text x="954" y="556">133.333</text>
        <branch name="XLXN_754">
            <wire x2="1584" y1="464" y2="464" x1="912" />
            <wire x2="1584" y1="432" y2="464" x1="1584" />
            <wire x2="1712" y1="432" y2="432" x1="1584" />
        </branch>
        <branch name="XLXN_755">
            <wire x2="1312" y1="528" y2="528" x1="912" />
            <wire x2="1312" y1="528" y2="624" x1="1312" />
        </branch>
        <branch name="CLKADC">
            <attrtext style="alignment:SOFT-BCENTER" attrname="Name" x="1776" y="816" type="branch" />
            <wire x2="1776" y1="816" y2="816" x1="1696" />
            <wire x2="1808" y1="816" y2="816" x1="1776" />
            <wire x2="1888" y1="816" y2="816" x1="1808" />
        </branch>
        <branch name="DDRCLK90">
            <attrtext style="alignment:SOFT-LEFT" attrname="Name" x="1712" y="688" type="branch" />
            <wire x2="1712" y1="688" y2="688" x1="1696" />
        </branch>
        <branch name="DDRCLKx2">
            <attrtext style="alignment:SOFT-LEFT" attrname="Name" x="1712" y="752" type="branch" />
            <wire x2="1712" y1="752" y2="752" x1="1696" />
        </branch>
        <branch name="DDRCLK">
            <attrtext style="alignment:SOFT-LEFT" attrname="Name" x="1712" y="880" type="branch" />
            <wire x2="1712" y1="880" y2="880" x1="1696" />
        </branch>
        <text x="1670" y="868">133.333</text>
        <text x="1682" y="804">200</text>
        <text x="1678" y="740">266</text>
    </sheet>
    <sheet sheetnum="3" width="1900" height="2688">
        <attr value="CM" name="LengthUnitName" />
        <attr value="4" name="GridsPerUnit" />
        <instance x="1968" y="2768" name="XLXI_106" orien="R0">
        </instance>
        <instance x="1104" y="1120" name="inst_uart0" orien="R0">
        </instance>
        <instance x="1104" y="2144" name="inst_uart1" orien="R0">
        </instance>
        <branch name="SINA">
            <wire x2="1104" y1="960" y2="960" x1="1088" />
        </branch>
        <branch name="SOUTA">
            <wire x2="1520" y1="928" y2="928" x1="1488" />
        </branch>
        <branch name="SINB">
            <wire x2="1104" y1="1984" y2="1984" x1="1072" />
        </branch>
        <branch name="SOUTB">
            <wire x2="1520" y1="1952" y2="1952" x1="1488" />
        </branch>
        <branch name="XLXN_551">
            <wire x2="1056" y1="176" y2="640" x1="1056" />
            <wire x2="1104" y1="640" y2="640" x1="1056" />
            <wire x2="1552" y1="176" y2="176" x1="1056" />
            <wire x2="1552" y1="176" y2="640" x1="1552" />
            <wire x2="1552" y1="640" y2="640" x1="1488" />
        </branch>
        <branch name="XLXN_552">
            <wire x2="1104" y1="1664" y2="1664" x1="1088" />
            <wire x2="1088" y1="1664" y2="2208" x1="1088" />
            <wire x2="1728" y1="2208" y2="2208" x1="1088" />
            <wire x2="1728" y1="1664" y2="1664" x1="1488" />
            <wire x2="1728" y1="1664" y2="2208" x1="1728" />
        </branch>
        <branch name="UARTCLK">
            <attrtext style="alignment:SOFT-RIGHT" attrname="Name" x="960" y="256" type="branch" />
            <wire x2="976" y1="256" y2="256" x1="960" />
            <wire x2="1104" y1="256" y2="256" x1="976" />
            <wire x2="976" y1="256" y2="1280" x1="976" />
            <wire x2="1104" y1="1280" y2="1280" x1="976" />
        </branch>
        <branch name="POR">
            <attrtext style="alignment:SOFT-RIGHT" attrname="Name" x="960" y="320" type="branch" />
            <wire x2="992" y1="320" y2="320" x1="960" />
            <wire x2="1104" y1="320" y2="320" x1="992" />
            <wire x2="992" y1="320" y2="1344" x1="992" />
            <wire x2="1104" y1="1344" y2="1344" x1="992" />
        </branch>
        <instance x="688" y="384" name="XLXI_193" orien="R0" />
        <branch name="XLXN_559">
            <wire x2="960" y1="384" y2="384" x1="752" />
            <wire x2="1104" y1="384" y2="384" x1="960" />
            <wire x2="960" y1="384" y2="1408" x1="960" />
            <wire x2="1104" y1="1408" y2="1408" x1="960" />
        </branch>
        <iomarker fontsize="28" x="1072" y="1984" name="SINB" orien="R180" />
        <iomarker fontsize="28" x="1520" y="1952" name="SOUTB" orien="R0" />
        <iomarker fontsize="28" x="1088" y="960" name="SINA" orien="R180" />
        <iomarker fontsize="28" x="1520" y="928" name="SOUTA" orien="R0" />
    </sheet>
</drawing>