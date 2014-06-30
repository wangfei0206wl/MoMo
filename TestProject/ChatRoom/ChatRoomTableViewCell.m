//
//  ChatRoomTableViewCell.m
//  TestProject
//
//  Created by wangfei on 14-5-26.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "ChatRoomTableViewCell.h"
#import "PublicDefines.h"

// 消息label的最大宽度
#define kMaxMessageLabelWidth       225
// 消息cell的最小高度
#define kMinMessageCellHeight       50
// 消息的字体大小
#define kMessageFont        [UIFont systemFontOfSize:15.0f]

@implementation ChatRoomTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createViews];
        [self initViews];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)createViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.contentView.backgroundColor = UIColorFromRGB(0xfbfbfb);

    _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 27, 27)];
    [self addSubview:_headImageView];

    CGSize size = [ChatRoomTableViewCell textSize:_messageItem.textBody];
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    _messageLabel.backgroundColor = [UIColor clearColor];
    _messageLabel.textAlignment = NSTextAlignmentLeft;
    _messageLabel.font = kMessageFont;
    _messageLabel.textColor = UIColorFromRGB(TEXT_NORMAL_COLOR);
    _messageLabel.numberOfLines = 0;
    [self addSubview:_messageLabel];
}

- (void)initViews {
    if (_messageItem.direction == INCOMING) {
        if (_messageItem.sender.sex == 1) {
            _headImageView.image = [UIImage imageNamed:@"icon_chat_boy"];
        }
        else {
            _headImageView.image = [UIImage imageNamed:@"icon_chat_girl"];
        }
    }
    else {
        if (_messageItem.receiver.sex == 1) {
            _headImageView.image = [UIImage imageNamed:@"icon_chat_boy"];
        }
        else {
            _headImageView.image = [UIImage imageNamed:@"icon_chat_girl"];
        }
    }
    
    _messageLabel.text = _messageItem.textBody;
    
    [self adjustViews];
}

- (id)initCellWithMessage:(ChatMessageItem *)item reuseIdentifier:(NSString *)reuseIdentifier {
    _messageItem = item;
    
    return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
}

- (void)initViewsWithMessage:(ChatMessageItem *)item {
    _messageItem = item;
    
    [self initViews];
}

- (void)adjustViews {
    CGRect frame;
    CGFloat height = [ChatRoomTableViewCell cellHeight:_messageItem.textBody];
    
    if (_messageItem.direction == INCOMING) {
        frame = _headImageView.frame;
        frame.origin.x = 10; frame.origin.y = (height - 27) / 2;
        _headImageView.frame = frame;
        
        CGSize size = [ChatRoomTableViewCell textSize:_messageItem.textBody];
        frame = _messageLabel.frame;
        frame.origin.x = 50; frame.origin.y = 0;frame.size = size;
        _messageLabel.frame = frame;
    }
    else {
        frame = _headImageView.frame;
        frame.origin.x = SCREEN_WIDTH - 10 - 27; frame.origin.y = (height - 27) / 2;
        _headImageView.frame = frame;
        
        CGSize size = [ChatRoomTableViewCell textSize:_messageItem.textBody];
        frame = _messageLabel.frame;
        frame.origin.x = SCREEN_WIDTH - 50 - size.width; frame.origin.y = 0;frame.size = size;
        _messageLabel.frame = frame;
    }
}

+ (CGFloat)heightInterval:(NSString *)message {
    NSString *cmpString = @"比较字符串";
    CGSize mtpSize = [message sizeWithFont:kMessageFont
                         constrainedToSize:CGSizeMake(kMaxMessageLabelWidth, MAXFLOAT)
                             lineBreakMode:NSLineBreakByWordWrapping];
    CGSize cmpSize = [cmpString sizeWithFont:kMessageFont
                           constrainedToSize:CGSizeMake(kMaxMessageLabelWidth, MAXFLOAT)
                               lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat interval = (mtpSize.height / cmpSize.height - 1) * cmpSize.height;
    if (interval <= 0) {
        interval = 0;
    }
    return interval;
}

+ (CGSize)textSize:(NSString *)message {
    NSString *cmpString = @"比较字符串";
    CGSize mtpSize = [message sizeWithFont:kMessageFont
                         constrainedToSize:CGSizeMake(kMaxMessageLabelWidth, MAXFLOAT)
                             lineBreakMode:NSLineBreakByWordWrapping];
    CGSize cmpSize = [cmpString sizeWithFont:kMessageFont
                           constrainedToSize:CGSizeMake(kMaxMessageLabelWidth, MAXFLOAT)
                               lineBreakMode:NSLineBreakByWordWrapping];
    CGSize destSize = CGSizeMake(kMaxMessageLabelWidth, kMinMessageCellHeight);
    CGFloat interval = (mtpSize.height / cmpSize.height - 1) * cmpSize.height;
    if (interval <= 0) {
        interval = 0;
        destSize.width =  mtpSize.width;
    }
    destSize.height += interval;

    return destSize;
}

+ (CGFloat)cellHeight:(NSString *)message {
    return kMinMessageCellHeight + [ChatRoomTableViewCell heightInterval:message];
}

@end

@implementation ChatRoomLeftCell

- (void)adjustViews {
    [super adjustViews];
}

@end

@implementation ChatRoomRightCell

- (void)adjustViews {
    [super adjustViews];
}

@end
