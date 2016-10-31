
# 第三方授权  

## 简介

卓易第三方登录(DroiOAuth) SDK是依托卓易市场、FreeMeOS庞大用户群体和海量优势资源，使得广大合作伙伴和第三方开发者接入卓易帐号功能后能够轻松享有卓易产品中的海量用户资源。用户可以方便快捷地使用卓易帐号登录开发者网站或者移动应用，同时为用户带来统一、友好的登录体验。
 
## 安装    
### 快速入门
由于DroiOAuth SDK依赖于DroiCore SDK，所以请在安装DroiOAuth SDK之前仔细阅读[快速入门](http://www.droibaas.com/Index/docFile/mark_id/24137.html) ，完成DroiCore SDK的安装。

### 使用CocoaPods方式集成（推荐）

DroiOAuth SDK使用CocoaPods作为函数库的管理工具。我们推荐您使用CocoaPods这种方式来安装SDK，这样可以大大简化安装DroiOAuth SDK的流程。如果您未安装CocoaPods，请参考[《CocoaPods安装和使用教程》](http://www.jianshu.com/p/b7bbf7f6af54)完成安装。CocoaPods安装完成后，请在项目根目录下创建一个Podfile文件，并添加如下内容（如果已有直接添加即可）：

```
pod 'DroiCoreSDK'
post_install do |installer|
    require './Pods/DroiCoreSDK/scripts/postInstall.rb'
    DroiCoreParser.installParser()
end
pod  'DroiOAuthSDK'
```
由于DroiOAuth SDK需依赖于DroiCore SDK，以上命令会安装DroiCore SDK并安装DroiPush SDK。如果之前已经安装过DroiCore SDK只需要添加

```
pod  'DroiOAuthSDK'
```
之后在控制台中cd到Podfile文件所在目录，执行如下命令完成安装。
	
```
pod  install
```	
###  手动集成


#### 1. 导入SDK到应用程序项目
将SDK包解压，在XCode中选择”Add files to 'Your project name’…”，将解压后的libs文件夹中的`DroiOAuth.framework`和`res`文件夹添加到你的工程目录中
#### 2. 添加必要的框架
点击Build Phases选项，在Link Binary With Libraries中添加以下内容：

* JavaScriptCore.framework

## 使用  

### 登录授权获取token
在适合的页面调用登录接口后，会自动跳转到登录页面，登录完成后会在callback回调用户的token信息，开发者可以使用token获取相应的用户信息。
示例：在当前页面中调用登录接口获取token

```
[DroiOAuth requestTokenWithViewController:self Callback:^(id object, NSError *error) {
        if (error == nil) {
            NSLog(@"Token data:%@",object);
            //这里可以将token 和 openid 保存起来 下次直接使用token 和 openid 登录
            NSString *token = [object objectForKey:@"token"];
            NSString *openid = [object objectForKey:@"openid"];
        }
    }];
```   
登陆成功后返回登录信息Json串，其中各字段及含义如下：

| 字段名称 | 类型 | 字段含义   |
| --------  | ----- | -----  |
| result | int | 登录结果代码   |
| desc   | String | 登录结果描述 |
| expire | long | token有效截止时间，超出token失效   |
| openid | String | 唯一标识应用户身份的id   |
| token  | String | 授予登录账号的令牌字段  |

### 检测token有效性
开发者获取到的token会有时效性，在过期时间后就会无效，所以如果本地保存了token信息的话，建议在请求用户信息之前先检测一下token的有效性。

```
[DroiOAuth checkTokenExpire:token Callback:^(id object, NSError *error) {
        if (error == nil) {
            NSLog(@"Check Token:%@",object);
        }
    }];
```
其中object包含token有效信息，字段如下所示：

| 字段名称 | 类型 | 字段含义   |
| --------  | ----- | -----  |
| result | int | 执行结果代码，包括错误码   |
| desc   | String | 执行结果描述，包括错误提示信息 |
| expire_in | long | token有效截止时间，超出token失效  |

若token失效，则object参数包含对应错误码及描述信息，如下：

| 错误码   | 含义   |
| -------- | -----  |
| -10020   | 会话不存在 |

### 获取用户相关信息
如果token正确，填入不同的scope可以获取到用户的不同信息，scope可以有以下三种：

| Scope      | 含义   |
| --------   | -----  |
| DroiOAuthScopeUserInfo   | 获取账户基本信息,包括用户昵称，性别等 |
| DroiOAuthScopeUserPhoneNumber  | 获取账户电话信息   |
| DroiOAuthScopeUserEmail   | 获取账户邮箱信息   |

示例：根据调用登录接口获取到的token数据获取用户基础信息、用户手机信息和用户邮箱信息

```
DroiOAuthScope scope = DroiOAuthScopeUserInfo|DroiOAuthScopeUserPhoneNumber|DroiOAuthScopeUserEmail;
[DroiOAuth getUserInfoWithToken:token openId:openid Scope:scope Callback:^(id object, NSError *error) {
        if (error == nil) {
            NSLog(@"userInfo:%@",object);
        }
    }];
```
**注意：后台创建应用时必须申请以上账号信息权限，若未申请，则获取对应信息失败**  
Callback回调object参数为账户信息，以下为各字段含义：

| 字段名称 | 范围 | 字段含义 |
| -------- | -----  | -----  |
| result   |   int   | 执行结果返回码，为0表示返回正常，否则为错误代码 |
| desc      |   String   | 执行结果描述 |
| gender   |   int   |   性别(0-男，1-女，2-保密)   |
| nickname |   String   |    账户昵称   |
| username |   String   |    用户手机号码   |
| mail     |   String   |    用户邮箱   |
| age      |   int   |    年龄   |
| birthday |   String   |    生日   |

获取账号信息失败，result字段则为对应错误码，以下为常见错误码的含义：

| 错误码        | 含义   |
| -------- | -----  |
| -10300   | 未获取到会话信息 |
| -10301   | id不符合会话记录 |
| -10302   |    权限不符   |
| -10303   |    未找到用户信息   |
| -10304   |    非法的权限   |
| -10020   |    会话不存在   |
| -10021   |    token不存在或已过期   |
| -10010   |    用户不存在   |
### 设置语言
DroiOAuth SDK 目前支持中文和英文两种语言，开发者可以调用以下接口更改登录页面的语言：

* DroiOAuthLanguageZH：中文
* DroiOAuthLanguageEN：英文

```
[DroiOAuth setLanguage:DroiOAuthLanguageEN];//设置语言为英文
```
### 设置Log开关
开发者可以根据需求开关DroiOAuth SDK内部的Log，建议在发布版本的时候关闭Log功能，节省资源。

```
[DroiOAuth setLogEnabled:NO];//关闭log
```
