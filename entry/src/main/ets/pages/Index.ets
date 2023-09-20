import picker from '@ohos.file.picker';
import grantPermission from '../utils/PermissionUtils';
import bundleManager from '@ohos.bundle.bundleManager';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import type { Permissions } from '@ohos.abilityAccessCtrl';
const TAG: string = '[Permission]';
import Want from '@ohos.app.ability.Want'
import common from "@ohos.app.ability.common"

const PERMISSIONS: Array<Permissions> = [
  'ohos.permission.CAMERA',
  'ohos.permission.MEDIA_LOCATION',
  'ohos.permission.MICROPHONE',
  'ohos.permission.READ_MEDIA',
  'ohos.permission.WRITE_MEDIA',
  'ohos.permission.INTERNET',
  'ohos.permission.GET_NETWORK_INFO'
];

import hilog from '@ohos.hilog';
let bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT;

@Entry
@Component
struct Index {
  @State message: string = 'Hello World'
  @State img: string = ''

  aboutToAppear() {
    // grantPermission(getContext(this)).then(res => {
    //   console.info(`权限申请成功  ${JSON.stringify(res)}`);
    // }).catch(rej => {
    //   console.info(`权限申请失败  ${JSON.stringify(rej)}`);
    // })
  }

  startAbilityTest(type, action) {
    let context = getContext(this) as common.UIAbilityContext
    let want = {
      "deviceId": "",
      "bundleName": "",
      "abilityName": "",
      "uri": "",
      "type": type,
      "action": action,
      "parameters": {},
      "entities": []
    };
    context.startAbility(want)
  }

  build() {
    Row() {
      Column({space:10}) {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Button("选择媒体").width('80%')
          .onClick(()=>{
            grantPermission(getContext(this)).then(res => {
              if (!res) { throw 'user reject granted'}
              console.info(`grantPermission success: ${JSON.stringify(res)}`);
              let PhotoSelectOptions = new picker.PhotoSelectOptions();
              PhotoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.VIDEO_TYPE;
              PhotoSelectOptions.maxSelectNumber = 2;
              let photoPicker = new picker.PhotoViewPicker();
              photoPicker.select(PhotoSelectOptions).then((PhotoSelectResult) => {
                console.info('applog:'+PhotoSelectResult.photoUris);
                this.img = PhotoSelectResult.photoUris[0];
                // this._Copy(this.img);
              }).catch((err) => {
                console.error('PhotoViewPicker.select failed with err: ' + err);
              });
            }).catch(rej => {
              console.info(`grantPermission fail: ${JSON.stringify(rej)}`);
            })
          })
        Button("选择文件").width('80%')
          .onClick(()=>{
            grantPermission(getContext(this)).then(res => {
              if (!res) { throw 'user reject granted'}
              console.info(`grantPermission success: ${JSON.stringify(res)}`);
              let DocumentSelectOptions = new picker.DocumentSelectOptions();
              // DocumentSelectOptions;
              // DocumentSelectOptions.maxSelectNumber = 2;
              let documentPicker = new picker.DocumentViewPicker();
              documentPicker.select(DocumentSelectOptions).then((DocumentSelectResult) => {
                console.info(`Document Select success: ${JSON.stringify(DocumentSelectResult)}`);
              }).catch((err) => {
                console.error('PhotoViewPicker.select failed with err: ' + err);
              });
            }).catch(rej => {
              console.info(`grantPermission fail: ${JSON.stringify(rej)}`);
            })
          })
        Button("want选择图片").width('80%')
          .onClick(()=>{
            this.startAbilityTest("image/*", "ohos.action.choose")
          })
        Button("want选择视频").width('80%')
          .onClick(()=>{
            this.startAbilityTest("video/*", "ohos.action.fileSelect")
          })
        Button("want选择图片和视频").width('80%')
          .onClick(()=>{
            this.startAbilityTest("*/*", "ohos.action.fileSelect")
          })

      }
      .width('100%')
    }
    .height('100%')
  }
}