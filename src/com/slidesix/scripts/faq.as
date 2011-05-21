
import mx.collections.ArrayCollection;
[Bindable] public var faqs:ArrayCollection = new ArrayCollection([
	{
	q: 'How do I upload a presentation?',
	a: 'At any time in the management console click on the \'Upload/Import\' button in the menu at the top of the page.  This will bring up a new window to handle your upload.  To get started click the \'Browse\' button in the bottom left corner of the upload window.  Select the presentation or presentations that you would like to upload to SlideSix.  The presentations must be one of the following file types:  PowerPoint (PPT, PPS), Acrobat (PDF), or OpenOffice Impress (ODP, SXI).  You can \'queue\' as many presentations as you\'d like, but the total queue must not exceed 50mb.  After you have selected the file that you would like to upload a new panel will open up next to the upload queue.  This panel allows you to edit the presentation title and description as well as enter some tags that will help others find your presentation.  Tags must be separated by a comma - for example: \'this,is,a,list,of,tags\'.  When you are ready to upload click \'Upload now\' in the bottom right corner of the upload window.  Each file in the upload queue will show a progress bar indicating how much of the file has been uploaded.  When all uploads are complete and have been finalized you can close the upload window.  Your presentation list will automatically be refreshed and you should see a thumbnail for each presentation that you just uploaded.',
	c: 'presentations',
	s: 1
	},
	{
	q: 'How do I import a presentation?',
	a: 'At any time in the management console click on the \'Upload/Import\' button in the menu at the top of the page.  This will bring up a new window to handle your import.  To get started click the \'Go To Import Screen\' button in the top right corner of the upload window.  Enter your Google Doc credentials (usually your email address and password), choose \'Google Docs\' from the Service drop down and then click \'Authenticate\'.  After you have authenticated the import queue will be filled with every presentation file that is associated with your Google Docs account.  Select which files you would like to import and then click \'Import Now\' in the bottom right corner.  When all imports are complete and have been finalized you can close the upload/import window.  Your presentation list will automatically be refreshed and you should see a thumbnail for each presentation that you just imported.',
	c: 'presentations',
	s: 2
	},
	{
	q: 'How do I delete a presentation?',
	a: 'On the presentation page (Click \'My Presentations\' in the top menu) single click a presentation thumbnail.  Open the presentation options menu (click on the \'gear\' icon below your presentation thumbnail) and select \'Delete Presentation\'.  Always remember that deletes are final and can not be undone.',
	c: 'presentations',
	s: 3
	},
	{
	q: 'How do I record video narration for a slide?',
	a: 'Single click a presentation and select \'Slides\' from the menu at the top of the Management Console (or double click a presentation thumbnail) to open the slide view page for that presentation.  Single click a slide thumbnail in the slide view to reveal a larger view of the given slide.  From the menu above the large version of your slide select \'Narrate\' (or double click a slide thumbnail) to open the media recording window.  In the media recording window choose the webcam that you would like to use from the drop down menu.  When you\'re ready to record your video narration click on the record button.  To stop recording click the stop button.',
	c: 'presentations,slides,multimedia',
	s: 4
	},
	{
	q: 'How do I record audio narration for a slide?',
	a: 'Single click a presentation and select \'Slides\' from the menu at the top of the Management Console (or double click a presentation thumbnail) to open the slide view page for that presentation.  Single click a slide thumbnail in the slide view to reveal a larger view of the given slide.  From the menu above the large version of your slide select \'Narrate\' (or double click a slide thumbnail) to open the media recording window.  In the media recording window click on the icon in the top right corner to disable video recording.  When you\'re ready to record your audio narration click on the record button.  To stop recording click the stop button.',
	c: 'presentations,slides,multimedia',
	s: 5
	},
	{
	q: 'Can I delete a single slide?',
	a: 'We do not currently offer the ability to delete individual slides.',
	c: 'presentations,slides',
	s: 6
	},
	{
	q: 'How do I delete exisiting slide narration?',
	a: 'Single click a presentation and select \'Slides\' from the menu at the top of the Management Console (or double click a presentation thumbnail) to open the slide view page for that presentation.  Single click a slide thumbnail in the slide view to reveal a larger view of the given slide.  From the menu above the large version of your slide select \'Narrate\' (or double click a slide thumbnail) to open the media recording window.  In the media recording window click on the icon in the top left corner to delete your existing narration.  Note:  deletes are final and can not be undone.',
	c: 'presentations,slides,multimedia',
	s: 6
	},
	{
	q: 'Why is there a \'film strip\' icon on my slide?',
	a: 'The filmstrip icon indicates that you have recorded narration within the Management Console for the given slide.',
	c: 'presentations,slides,multimedia',
	s: 7
	},
	{
	q: 'How do I embed external videos?',
	a: 'Single click a presentation and select \'Slides\' from the menu at the top of the Management Console (or double click a presentation thumbnail) to open the slide view page for that presentation.  Single click a slide thumbnail in the slide view to reveal a larger view of the given slide.  From the menu above the large version of your slide select \'Video\' to open the external video search window.  In the external video search window you can either enter the full URL to an existing YouTube or Vimeo video or search for existing videos by keyword.  When you search by keyword you will be presented with a thumbnail for each video that matches your search.  Hover your mouse over the thumbnail to get additional information about the video clip.  Single click a thumbnail and select \'Preview\' (or double click on the thumbnail) to preview the video.  Click \'Attach\' to associate the video with the chosen slide.  Associated external videos will be played immediately after the chosen slide in your presentation.',
	c: 'presentations,slides,multimedia',
	s: 8
	},
	{
	q: 'Why can\'t I find a certain external video?',
	a: 'We do our best to search Vimeo and YouTube for your keyword but sometimes we may not be able to find the exact video that you are looking for.  If you are sure that a video exists you can simply paste the exact URL for the video into the external media search window and we should be able to find it.  You can also try searching by YouTube or Vimeo username or Vimeo channel or group name.',
	c: 'presentations,slides,multimedia',
	s: 9
	},
	{
	q: 'I can\'t find my presentation, where is it?',
	a: 'If you have a lot of presentations it can be difficult to quickly find the one you are looking for.  In the bottom portion of the panel where your presentation thumbnails are shown you can perform a search to filter your presentations.  Enter a keyword and the presentation thumbnails will be filtered to show only presentations that match the keyword.  Clear the search box to unfilter the list.',
	c: 'presentations',
	s: 10
	},
	{
	q: 'Can I create a private presentation?',
	a: 'Yes.  When uploading a presentation you can specify a password to make your presentation private.  Private presentations do not appear in any search results on SlideSix and are not indexed by search engines.  Only share your password with people that you trust.',
	c: 'presentations',
	s: 11
	},
	{
	q: 'Is my presentation private or public?',
	a: 'If you\'re not sure you can single click on a presentation thumbnail to open the presentation details panel.  In the bottom portion of the presentation details panel, under the \'Metadata\' panel look in the first text box labeled \'Private\'.  This tells you if your presentation is private or not.',
	c: 'presentations',
	s: 12
	},
	{
	q: 'Can I change my presentation password?',
	a: 'Yes.  Single click on a presentation thumbnail to open the presentation details panel.  In the top portion of the presentation details panel, under the \'Properties\' panel you can edit your presentation password, confirm it, and then click \'Save Presentation\'.',
	c: 'presentations',
	s: 13
	},
	{
	q: 'Can I make a public presentation private?',
	a: 'Yes.  Single click on a presentation thumbnail to open the presentation details panel.  In the top portion of the presentation details panel, under the \'Properties\' panel you can add a presentation password, confirm it, and then click \'Save Presentation\'.',
	c: 'presentations',
	s: 14
	},
	{
	q: 'Can I make a private presentation public?',
	a: 'Yes.  Open the presentation options menu (click on the \'gear\' icon below your presentation thumbnail) and select \'Remove Password\'.  If this option is unavailable then the presentation is already public.',
	c: 'presentations',
	s: 15
	},
	{
	q: 'Can I embed attachments in my presentation?',
	a: 'Yes.  Open the presentation options menu (click on the \'gear\' icon below your presentation thumbnail) and select \'Add Attachment\'.  Your attachment will be automatically uploaded and will be available to download by presentation viewers.  Viewers can download your attachment by clicking the \'Menu\' button in the presentation viewer and choosing \'Download Attachment\'.  Attachments must be ZIP files up to 5mb.',
	c: 'presentations',
	s: 16
	},
	{
	q: 'How do I view a presentation attachment?',
	a: 'If you have previously uploaded an attachment you can view it by opening the presentation options menu (click on the \'gear\' icon below your presentation thumbnail) and selecting \'View Attachment\'.  If this option is not available in the presentation options menu then your presentation does not currently have an attachment associated with it.',
	c: 'presentations',
	s: 17
	},
	{
	q: 'How do I delete a presentation attachment?',
	a: 'If you have previously uploaded an attachment you can delete it by opening the presentation options menu (click on the \'gear\' icon below your presentation thumbnail) and selecting \'Delete Attachment\'.  If this option is not available in the presentation options menu then your presentation does not currently have an attachment associated with it.',
	c: 'presentations',
	s: 18
	},
	{
	q: 'What does \'Published\' mean?',
	a: 'If your presentation is published (and not password protected) that means it is visible to anyone who visits SlideSix and is indexed and searchable.',
	c: 'presentations',
	s: 19
	},
	{
	q: 'How do I create an unpublished presentation?',
	a: 'When uploading your presentation uncheck the \'Auto Publish This Presentation\' box.',
	c: 'presentations',
	s: 20
	},
	{
	q: 'How do I publish an unpublished presentation?',
	a: 'Open the presentation options menu (click on the \'gear\' icon below your presentation thumbnail) and select \'Publish Presentation\'.  If this option is unavailable then your presentation is already published.',
	c: 'presentations',
	s: 21
	},
	{
	q: 'How do I know if my presentation is published?',
	a: 'If you\'re not sure you can single click on a presentation thumbnail to open the presentation details panel.  In the bottom portion of the presentation details panel, under the \'Metadata\' panel look in the text box labeled \'Published On\'.  If there is a date in this field then your presentation has been published.  If there is no date in this field then your presentation is not yet published.',
	c: 'presentations',
	s: 22
	},
	{
	q: 'Why would I want to not publish my presentation?',
	a: 'Some people prefer to keep their presentations unpublished until they have enhanced their slides with multimedia narration.',
	c: 'presentations',
	s: 23
	},
	{
	q: 'Can I unpublish a presentation?',
	a: 'No.  Instead you can delete it or set a password on it to make it private.',
	c: 'presentations',
	s: 24
	},
	{
	q: 'What is \'Presentation Analytics\'?',
	a: 'Presentation Analytics, accessible via the presentation options menu (click on the \'gear\' icon below your presentation thumbnail), gives you detailed analytical data about your presentations on SlideSix.  You will be able to see how many viewers have viewed your presentation over the last 30 days and how long they spent viewing it - including slide level details.',
	c: 'presentations,slides',
	s: 25
	},
	{
	q: 'Why is \'Presentation Analytics\' disabled in the menu?',
	a: 'Presentation Analytics is currently limited to select users.  If you would like to test it out please visit <a href="/labs" target="_blank"><font color="#0066ff">SlideSix Labs</font></a> to apply.',
	c: 'presentations,slides',
	s: 26
	},
	{
	q: 'What is \'Collaborate\'?',
	a: 'Collaborate is a dedicated room for your account on SlideSix that can be used to present your SlideSix presentations in a virtual environment.  To broadcast your presentations you will need the SlideSix desktop application.',
	c: 'presentations,slides',
	s: 27
	},
	{
	q: 'Can I make my \'Collaborate\' room private?',
	a: 'If enabled you can enter a password for your Collborate room while editing your profile.  Click \'My Profile\' in the top menu and look for the text inputs to enter and confirm your collaborate password.  Make sure you save your profile after any changes by clicking \'Save Profile\' in the bottom corner of the profile page.<br /><b>This password is different from your SlideSix account password and should only be shared with people you trust.</b>',
	c: 'presentations,slides',
	s: 28
	},
	{
	q: 'Can I make my \'Collaborate\' room public?',
	a: 'If enabled and your Collaborate room is currently private you can make it public while editing your profile.  Click \'My Profile\' in the top menu and check the \'Remove Collaborate Password\' checkbox.  Make sure you save your profile after any changes by clicking \'Save Profile\' in the bottom corner of the profile page.',
	c: 'presentations,slides',
	s: 29
	},
	{
	q: 'Why is \'Collaborate\' disabled in the menu?',
	a: 'Collaborate is currently limited to select users.  If you would like to test it out please visit <a href="/labs" target="_blank"><font color="#0066ff">SlideSix Labs</font></a> to apply.',
	c: 'presentations,slides',
	s: 30
	},
	{
	q: 'How do i edit my profile?',
	a: 'In the Management Console click on \'Profile\' in the top menu bar.  You will be able to edit your email address, bio and SlideSix password, and Collaborate password (if enabled) from the profile edit page.  You can also upload a profile picture from the by clicking \'Upload Profile Pic\' from the menu at the bottom of the profile edit page.',
	c: 'profile',
	s: 31
	},
	{
	q: 'How do i add a profile picture?',
	a: 'In the Management Console click on \'Profile\' in the top menu bar.  You will be able to edit your email address, bio and SlideSix password, and Collaborate password (if enabled) from the profile edit page.  You can also upload a profile picture from the by clicking \'Upload Profile Pic\' from the menu at the bottom of the profile edit page.',
	c: 'profile',
	s: 32
	},
	{
	q: 'How do i change my account password?',
	a: 'In the Management Console click on \'Profile\' in the top menu bar.  You will be able to edit your email address, bio and SlideSix password, and Collaborate password (if enabled) from the profile edit page.',
	c: 'profile',
	s: 33
	},
	{
	q: 'How do i create a new group?',
	a: 'In the Management Console click on \'Groups\' in the top menu bar to open the Group editor. In the group editor click \'New Group\' in the menu at the bottom of the page.  Enter a group name and description, choose how members should be approved and then click \'Save Group\'.',
	c: 'groups',
	s: 34
	},
	{
	q: 'How do i edit a group?',
	a: 'In the Management Console click on \'Groups\' in the top menu bar to open the Group editor.  Single click on an existing group thumbnail to reveal the group details panel.  Enter a group name and description, choose how members should be approved and then click \'Save Group\'.',
	c: 'groups',
	s: 35
	},
	{
	q: 'How do i add a picture for my group?',
	a: 'In the Management Console click on \'Groups\' in the top menu bar to open the Group editor.  Click \'Group Pic\' from the menu at the bottom of the group editor page and select a picture for your group (PNG, JPG, GIF) to upload your picture.  Once the picture is uploaded you will need to crop it to fit our standard size.  In the picture crop window drag the highlighted square to the area that you would like to use for your group picture and click \'Crop Image\'.',
	c: 'groups',
	s: 36
	},
	{
	q: 'How do i approve group members?',
	a: 'In the Management Console click on \'Groups\' in the top menu bar to open the Group editor.  Single click on an existing group thumbnail and select the \'Pending Members\' tab from the group details panel.  Choose whether to approve or deny each member and click \'Save Memberships\'.',
	c: 'groups',
	s: 37
	},
	{
	q: 'Can I create a private group?',
	a: 'Private groups are not supported at this time.',
	c: 'groups',
	s: 38
	},
	{
	q: 'Can I delete a group?',
	a: 'We do not yet offer the ability to delete a group.  Contact us via our <a href="/contact" target="_blank"><font color="#0066ff">Contact Form</font></a> if you have the need to delete a group for any reason.',
	c: 'groups',
	s: 39
	}
	
	/* {
	q: '',
	a: '',
	c: '',
	s: 1
	} */
]);
