import picker from '@ohos.file.picker';
import grantPermission from '../utils/PermissionUtils';
import bundleManager from '@ohos.bundle.bundleManager';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import type { Permissions } from '@ohos.abilityAccessCtrl';
const TAG: string = '[Permission]';

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

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Button("选择文件").width('80%')
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
      }
      .width('100%')
    }
    .height('100%')
  }
}