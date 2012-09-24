//
//  sflyViewController.m
//  displaypicsInstagram
//
//  Created by kmd on 9/16/12.
//  Copyright (c) 2012 kmd. All rights reserved.
//

#import "sflyViewController.h"

@implementation sflyViewController
@synthesize img1;
@synthesize img2;
@synthesize img3;
@synthesize jsondata;
@synthesize jsondataDownloadIndicator;
@synthesize jsonstring;
@synthesize jsonthumbnailsstring;
@synthesize imgv1;
@synthesize imgv2;
@synthesize imgv3;
@synthesize tbview;
@synthesize downloadedimages;
@synthesize jsonHighresstring;

- (void)viewDidLoad
{

    [super viewDidLoad];
    // global cnt of views inside the scroll view is thousand
    
    gCnt = 100;
    mPositionX = 0;
    
    
     
    downloadedimages = [NSMutableArray alloc];
    
    //tbview = [[UITableView alloc] initWithFrame:self.view.bounds];
    [tbview setDelegate:self];
    [tbview setDataSource:self];
    [self.view addSubview:tbview];
    /*
    CGRect rect = CGRectMake(0.0f, 40.0f, 150, 150);
    imgv1 = [[UIImageView alloc] initWithFrame:rect];
    [imgv1 setImage:img1];
    [self.view addSubview:imgv1];
    
    rect = CGRectMake(0.0f, 120.0f, 150, 150);
    imgv2 = [[UIImageView alloc] initWithFrame:rect];
    [imgv2 setImage:img2];
    [self.view addSubview:imgv2];
    
    rect = CGRectMake(0.0f, 180.0f, 150, 150);
    imgv3 = [[UIImageView alloc] initWithFrame:rect];
    [imgv3 setImage:img3];
    [self.view addSubview:imgv3];
     */
    
	// Do any additional setup after loading the view, typically from a nib.
    // Release any retained subviews of the main view.
    jsonthumbnailsstring = [[NSMutableArray alloc] initWithCapacity:1];
    jsonHighresstring = [[NSMutableArray alloc] initWithCapacity:1];
    
    // get the json string in a nsstring first
    NSString *_jsonstring =
    @"https://api.instagram.com/v1/media/popular?access_token=236077.f59def8.357c3c9d5d8645218fc8b0a255df7ee0&next_url=1";
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:_jsonstring]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
   
   
    //jsondataDownloadIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
	//jsondataDownloadIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
	//jsondataDownloadIndicator.center = self.view.center;
	//[self.view addSubview: jsondataDownloadIndicator];
    
    // create the connection with the request
    // and start loading the data
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        jsondata = [NSMutableData data];
        
        // start creating the views inside scroll
        // and adding the indicator
        NSArray *colors = [NSArray arrayWithObjects:[UIColor redColor], [UIColor greenColor], [UIColor blueColor], nil];
        
        int posX = 0;
        int colorCnt = 0;
        for (int i = 0; i < gCnt; i++) {
            CGRect frame;
            frame.origin.x = posX;
            frame.origin.y = 0;
            frame.size = parentScrollview.frame.size;
            
            UIView *subview = [[UIView alloc] initWithFrame:frame];
            if(colorCnt > 2)
                colorCnt = 0;
            subview.backgroundColor = [colors objectAtIndex:colorCnt];
            colorCnt++;
            
            //jsondataDownloadIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            jsondataDownloadIndicator = [[UIActivityIndicatorView alloc] init];
            jsondataDownloadIndicator.frame = CGRectMake(posX+15, 30.0, 40.0, 40.0);
            // jsondataDownloadIndicator.center = subview.center;
            jsondataDownloadIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
            [subview addSubview:jsondataDownloadIndicator];
            [jsondataDownloadIndicator startAnimating];
            [parentScrollview addSubview:subview];
            [parentScrollview addSubview:jsondataDownloadIndicator];
            parentScrollview.pagingEnabled = TRUE;
            posX = posX + 100;
            //[parentScrollview addSubview:jsondataDownloadIndicator];
             
        }
        
        parentScrollview.contentSize = CGSizeMake(parentScrollview.frame.size.width * gCnt, parentScrollview.frame.size.height);

    } else {
        // Inform the user that the connection failed.
        NSLog(@"connection failed");
        [jsondataDownloadIndicator stopAnimating];
    }
    
}

int ghighResUrl=0;
UIView *tmpClickView;
-(void) loadHighResolutionImage:(UITapGestureRecognizer *)recognizer
{
    UIView *headerView = recognizer.view;
    [self.view addSubview:jsondataDownloadIndicator];
    [jsondataDownloadIndicator startAnimating];
    NSLog(@"tag %d", headerView.tag);
    
    /*
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(aMethod:) forControlEvents:UIControlEventTouchDown];
    [button setTitle:@"Refresh" forState:UIControlStateNormal];

    button.frame = CGRectMake(80.0, self.view.frame.size.height-50, 160.0, 40.0);
    */
    // load the images in main view
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[jsonHighresstring objectAtIndex:headerView.tag]]]];
            // image size 150, 150
            //NSLog(@"image size width %f , height %f", image.size.width, image.size.height);
    CGRect rect = CGRectMake(0, self.view.frame.origin.y + headerView.frame.size.height-20, self.view.frame.size.width, self.view.frame.size.height);
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:rect];
            [imageView setImage:image];
            [self.view addSubview:imageView];
    //[self.view addSubview:button];
    [jsondataDownloadIndicator stopAnimating];
    
}

-(void) loadHighResolutionImage_table:(UITapGestureRecognizer *)recognizer
{
    tmpClickView = [[UIView alloc] init];
    // call reload table cells
    NSArray *indexPaths = [NSArray arrayWithObjects:
                           [NSIndexPath indexPathForRow:0 inSection:0],
                           // Add some more index paths if you want here
                           nil];
    UIView *headerView = recognizer.view;
    tmpClickView = headerView;
    NSLog(@"tag %d", tmpClickView.tag);
    //[self.tbview reloadRowsAtIndexPaths:indexPaths withRowAnimation: UITableViewRowAnimationFade];
    [self.tbview reloadData];
    return;
    [self.view addSubview:jsondataDownloadIndicator];
    [jsondataDownloadIndicator startAnimating];
    
    /*
     UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
     [button addTarget:self
     action:@selector(aMethod:) forControlEvents:UIControlEventTouchDown];
     [button setTitle:@"Refresh" forState:UIControlStateNormal];
     
     button.frame = CGRectMake(80.0, self.view.frame.size.height-50, 160.0, 40.0);
     */
    // load the images in main view
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[jsonHighresstring objectAtIndex:headerView.tag]]]];
    // image size 150, 150
    //NSLog(@"image size width %f , height %f", image.size.width, image.size.height);
    CGRect rect = CGRectMake(0, self.view.frame.origin.y + headerView.frame.size.height-20, self.view.frame.size.width, self.view.frame.size.height);
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:rect];
    [imageView setImage:image];
    [self.view addSubview:imageView];
    //[self.view addSubview:button];
    [jsondataDownloadIndicator stopAnimating];
    
}

-(void) loadScrollImages:(NSData*)image:(NSInteger)cntr;
{
    CGRect frame;
    frame.origin.x = mPositionX;
    frame.origin.y = 0;
    frame.size = parentScrollview.frame.size;
    NSLog(@"cntr - > %d", cntr);
    UIView *subview = [[UIView alloc] initWithFrame:frame];
    subview.tag = cntr;
    //UIView *subview = [thumbnailViews objectAtIndex:cntr];
    UIImage *img = [[UIImage alloc] initWithData:image];
    UIImageView * imageView = [[UIImageView alloc] initWithImage:img];
    
    //The setup code (in viewDidLoad in your view controller)
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(loadHighResolutionImage_table:)];
    
    [subview addGestureRecognizer:singleFingerTap];
    [subview addSubview:imageView];
    ghighResUrl = cntr;
    [thumbnailViews addObject:subview];
    [jsondataDownloadIndicator stopAnimating];
    [parentScrollview addSubview:subview];
    parentScrollview.pagingEnabled = TRUE;
    mPositionX = mPositionX + 100;

}
-(void) loadThumbnails
{
    // check the size of the mutable array
    if(gCnt < [jsonthumbnailsstring count])
    {
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[jsonthumbnailsstring objectAtIndex:gCnt]]]];
        // image size 150, 150
        //NSLog(@"image size width %f , height %f", image.size.width, image.size.height);
        CGRect rect = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:rect];
        [imageView setImage:image];
        [self.view addSubview:imageView];
        gCnt++;
        
        if(gCnt < [jsonthumbnailsstring count])
        {
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[jsonthumbnailsstring objectAtIndex:gCnt]]]];
            rect = CGRectMake(0.0f, 150.0f, image.size.width, image.size.height);
            imgv2 = [[UIImageView alloc] initWithFrame:rect];
            [imgv2 setImage:image];
            [self.view addSubview:imgv2];
            gCnt++;
            
            if(gCnt < [jsonthumbnailsstring count])
            {
                
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[jsonthumbnailsstring objectAtIndex:gCnt]]]];
                rect = CGRectMake(0.0f, 300.0f, image.size.width, image.size.height);
                imgv2 = [[UIImageView alloc] initWithFrame:rect];
                [imgv2 setImage:image];
                [self.view addSubview:imgv2];
            }
        }
    }
}

- (void)viewDidUnload
{
    parentScrollview = nil;
    displayPics = nil;
    [super viewDidUnload];
    
}
-(void) loadThumbnails_
{
 
    NSString *_jsonstring;
    int cntr=0;
    for (_jsonstring in jsonthumbnailsstring) {
        NSURLRequest *req=[NSURLRequest requestWithURL:[NSURL URLWithString:_jsonstring]];
        
        NSError        *error = nil;
        NSURLResponse  *response = nil;
        
        NSData *newData = [NSURLConnection sendSynchronousRequest: req returningResponse: &response error: &error];
        
        if (error)
        {
            NSLog(@"error ");
            
        }else{
            NSString *responseString = [[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"loadmainqueue");
                [self loadScrollImages:newData :cntr];
            });
            cntr++;
        }
        
    }
// get the json string in a nsstring first
//        NSString *_jsonstring =
//      @"http://www.kmdarshan.com";
}

-(void) getThumbnailsSourceFromJsonString
{
    NSError* error;
    NSDictionary* jsonresponse = [NSJSONSerialization
                                  JSONObjectWithData:jsondata
                                  options:kNilOptions
                                  error:&error];

    NSDictionary *metacode = [jsonresponse objectForKey:@"meta"];
    NSNumber *errorcode = [metacode objectForKey:@"code"];
    NSNumber *gooderrcode = [[NSNumber alloc] initWithInt:200];
    if ([errorcode isEqualToNumber:gooderrcode] == YES) {
        
        NSArray* dataarray = [jsonresponse objectForKey:@"data"];
        for (NSDictionary *tmpdata in dataarray) {
            @try {
                
                //NSString *tmplowres = [tmpdata valueForKeyPath:@"images.low_resolution.url"];
                //NSString *tmphighres = [tmpdata valueForKeyPath:@"images.standard_resolution.url"];
                NSString *tmpthumbnail = [tmpdata valueForKeyPath:@"images.thumbnail.url"];
                [jsonthumbnailsstring addObject:tmpthumbnail];
                
                tmpthumbnail = [tmpdata valueForKeyPath:@"images.standard_resolution.url"];
                [jsonHighresstring addObject:tmpthumbnail];
                
            }@catch (NSException *exception) {
                NSLog(@"ignore exception --- ");
            }
        }
    }
    
    // call image loader
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadThumbnails_];
    });
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    NSLog(@"Succeeded! Received %d bytes of data",[jsondata length]);
    //[jsondataDownloadIndicator stopAnimating];
    //jsonstring = [[NSString alloc] initWithData:jsondata encoding:NSASCIIStringEncoding];
    [self getThumbnailsSourceFromJsonString];
    [tbview reloadData];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    [jsondata setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [jsondata appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    [jsondataDownloadIndicator stopAnimating];
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark Table view methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 400;
    }
    
    return 100;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([jsonthumbnailsstring count] < 10)
        return 1;
	return [jsonthumbnailsstring count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = @"";
    NSLog(@"row %d ", indexPath.row);
    if(indexPath.row == 0)
    {
        cell.textLabel.text = @"";
        if([jsonHighresstring count] > 0)
        {
            // this is the view retrieved from cicking on a thumbnail
            UIView *headerView = tmpClickView;
            NSLog(@"tag %d %d cell", headerView.tag, indexPath.row);
            
            // load the images in main view
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[jsonHighresstring objectAtIndex:headerView.tag]]]];
            // image size 150, 150
            CGRect rect = CGRectMake(0, cell.frame.origin.y , cell.frame.size.width, cell.frame.size.height);
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:rect];
            [imageView setImage:image];
            [cell addSubview:imageView];
        }
    }
    /*
     
    // Set up the cell...
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    //cell.textLabel.text = [NSString	 stringWithFormat:@"Cell Row #%d", [indexPath row]];
    cell.textLabel.text = @"Loading ....";
    
    // add a activity indicator for each row
    jsondataDownloadIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	//jsondataDownloadIndicator.frame = CGRectMake(0.0, 0.0, 30.0, 30.0);
	//jsondataDownloadIndicator.center = cell.center;
    [jsondataDownloadIndicator startAnimating];
	[cell setAccessoryView:jsondataDownloadIndicator];
    
    UIActivityIndicatorView *activityView =
    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityView startAnimating];
    [cell setAccessoryView:activityView];
    */
    return cell;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
		   editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
	return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// open a alert with an OK and cancel button
	NSString *alertString = [NSString stringWithFormat:@"Clicked on row #%d", [indexPath row]];
	//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertString message:@"" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
	//[alert show];
}
@end
