//
//  PerfectInfoViewController.m
//  SCdemo
//
//  Created by appteam on 2016/12/8.
//  Copyright © 2016年 appteam. All rights reserved.
//

#import "PerfectInfoViewController.h"

typedef NS_ENUM(NSUInteger, Gender) {
    Male = 100,
    Female,
};

@interface PerfectInfoViewController ()<TBActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UIButton *portrait;
@property (nonatomic, assign) Gender gender;
@property (nonatomic, strong) UIImageView *maleSelect;
@property (nonatomic, strong) UIImageView *femaleSelect;
@end

@implementation PerfectInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"Perfect Info", nil);
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:@"#00c8e3"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.clipsToBounds = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#00c8e3"]}];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)setupUI
{
    self.portrait = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.cornerRadius = 40;
        button.layer.masksToBounds = YES;
        [button setImage:[UIImage imageNamed:@"头像"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(portraitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [button makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.width.height.equalTo(80);
            make.top.equalTo(150);
        }];
        
        button;
    });
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.text = NSLocalizedString(@"Your real name", nil);
    nameLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:nameLabel];
    [nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.portrait.bottom).offset(50);
        make.width.equalTo(200);
        make.height.equalTo(30);
    }];
    
    UITextField *nameField = [[UITextField alloc] init];
    nameField.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nameField];
    [nameField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.bottom);
        make.width.equalTo(200);
        make.centerX.equalTo(self.view);
        make.height.equalTo(50);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(nameField);
        make.height.equalTo(1);
    }];
    
    UILabel *gender = [[UILabel alloc] init];
    gender.textAlignment = NSTextAlignmentCenter;
    gender.text = NSLocalizedString(@"Your gender", nil);
    gender.textColor = [UIColor lightGrayColor];
    [self.view addSubview:gender];
    [gender makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(nameField.bottom).offset(50);
        make.width.equalTo(200);
        make.height.equalTo(30);
    }];
    
    UIButton *male = [UIButton buttonWithType:UIButtonTypeCustom];
    male.tag = Male;
    [male setImage:[UIImage imageNamed:@"男"] forState:UIControlStateNormal];
    [male addTarget:self action:@selector(selectGender:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:male];
    
    UIButton *female = [UIButton buttonWithType:UIButtonTypeCustom];
    female.tag = Female;
    [female setImage:[UIImage imageNamed:@"女"] forState:UIControlStateNormal];
    [female addTarget:self action:@selector(selectGender:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:female];
    
    NSMutableArray *btns = [[NSMutableArray alloc] init];
    [btns addObject:male];
    [btns addObject:female];
    
    [btns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:60 leadSpacing:100 tailSpacing:100];
    [btns makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(gender.bottom).offset(50);
        make.height.equalTo(60);
    }];
    
    self.maleSelect = ({
        UIImageView *maleSelect = [[UIImageView alloc] init];
        maleSelect.image = [UIImage imageNamed:@"选中"];
        [male addSubview:maleSelect];
        [maleSelect makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(male).offset(5);
            make.width.height.equalTo(20);
        }];
        maleSelect.hidden = NO;
        self.gender = Male;
        
        maleSelect;
    });
    
    self.femaleSelect = ({
        UIImageView *femaleSelect = [[UIImageView alloc] init];
        femaleSelect.image = [UIImage imageNamed:@"选中"];
        [female addSubview:femaleSelect];
        [femaleSelect makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(female).offset(5);
            make.width.height.equalTo(20);
        }];
        femaleSelect.hidden = YES;
        
        femaleSelect;
    });
    
    
    
    UIButton *join = [UIButton buttonWithType:UIButtonTypeCustom];
    join.backgroundColor = [UIColor colorWithHexString:@"#00c8e3"];
    [join setTitle:NSLocalizedString(@"Join now", nil) forState:UIControlStateNormal];
    [self.view addSubview:join];
    [join makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(50);
    }];
    
}

- (void)selectGender:(UIButton *)sender
{
    self.gender = sender.tag;
    if (sender.tag == Male) {
        self.maleSelect.hidden = NO;
        self.femaleSelect.hidden = YES;
    } else if (sender.tag == Female) {
        self.maleSelect.hidden = YES;
        self.femaleSelect.hidden = NO;
    }
}

- (void)portraitBtnClick:(UIButton *)sender
{
    TBActionSheet *sheet = [[TBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Camera", nil),NSLocalizedString(@"Photo Library", nil), nil];
    sheet.ambientColor = [UIColor colorWithHexString:@"#00c8e3"];
    sheet.cancelButtonColor = [UIColor whiteColor];
    sheet.tintColor = [UIColor whiteColor];
    [sheet show];
}

- (void)actionSheet:(TBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        return;
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
        imagePickerVC.delegate = self;
        if (buttonIndex == 0) {
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerVC.showsCameraControls = YES;
        } else if (buttonIndex == 1) {
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerVC.allowsEditing = YES;
            imagePickerVC.mediaTypes = @[(NSString *)kUTTypeImage];
        }
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [self.portrait setImage:image forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
