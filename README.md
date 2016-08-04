# KBFProfanityFilter

------------------


This project provides obj-c method to filter the profanity word.

Just open the demo in XCode and run it.

If your input is

`谁有色情图片`

the output will be

`谁有**图片`

The key method is

```
/**
 Returns a string with offending words replaced by "∗"
 */
- (NSString*)filteringString:(NSString*)string;
```

__Sample__


```
[[KBFProfanityFilter sharedInstance] filteringString:@"谁有色情图片"];// outputs: "谁有**图片"
```


__Notice__

To create your own Profanity Word List

1) go to script folder

2) run lua in shell:

```
lua profanity.lua -f words.txt
```

3) copy the json string in the console and convert it to a plist using plutil or the link [json2plist](http://json2plist.sinaapp.com)

4) add the plist to the your project


