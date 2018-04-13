BEGIN{
	num_D = 0;
	num_s = 0;
	num_r = 0;

	rate_drop = 0;
	sum_delay = 0;
	average_delay = 0;
}
{
	event = $1;
	time = $2;
	node = $3;
	trace_type = $4;
	flag = $5;
	uid = $6;
	pkt_type = $7;
	pkt_size = $8;

	if(event=="s"&&trace_type=="AGT"&&pkt_type=="cbr")
	{	send_time[uid] = time;
		num_s++;
}

	if(event=="r"&&trace_type=="AGT"&&pkt_type=="cbr")
	{	delay[uid] = time-send_time[uid];
		num_r++;
}

	if(event=="D"&&pkt_type=="cbr")
		delay[uid] = -1;
}

END{
	num_D = num_s-num_r;
	rate_drop = num_D/num_s*100.0;

	for(i=0;i<num_s;i++){
		if(delay[i]>=0)
			sum_delay+=delay[i];
}
	average_delay = sum_delay/num_r;

	printf("num of packets droped:%d\n",num_D);
	printf("num of packets sent:%d\n",num_s);
	printf("drop rate:%.3f % % \n",rate_drop);
	printf("average delay time:%.9f\n",average_delay);
}
