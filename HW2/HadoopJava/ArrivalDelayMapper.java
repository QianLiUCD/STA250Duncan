import java.io.IOException;

import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;

import org.apache.hadoop.mapreduce.Mapper;

public class ArrivalDelayMapper extends Mapper<LongWritable, Text, IntWritable, IntWritable> {

    public void map(LongWritable key, Text value, Context context) 
      	            throws IOException, InterruptedException 
    {
    double year;	
	double temp;
	int delay;
	
	String[] els = value.toString().split(",");
	
	try{
		year = Double.parseDouble(els[0]);
	}
	catch(Exception e){
		return;
	}
	
	if (year > 2007){
	
	try{
		temp = Double.parseDouble(els[44]);
	}
	catch(Exception e){
		return;
	}
	    delay = (int)Math.floor(temp);
	    context.write(new IntWritable(delay), new IntWritable(1));
	}
	else{
	try{
		temp = Double.parseDouble(els[14]);
	}
	catch(Exception e){
		return;
	}
		delay = (int)Math.floor(temp);
		context.write(new IntWritable(delay), new IntWritable(1));
	}
		
	}
    
}