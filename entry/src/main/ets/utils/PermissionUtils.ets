import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import type { Permissions } from '@ohos.abilityAccessCtrl';
import bundleManager from '@ohos.bundle.bundleManager';

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

let bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION;

export default async function grantPermission(context): Promise<boolean> {

  try {

    let bundleInfo: bundleManager.BundleInfo = await bundleManager.getBundleInfoForSelf(bundleFlags)
    let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
    let tokenId = appInfo.accessTokenId;

    let atManager = abilityAccessCtrl.createAtManager();
    let permsPendingList: Array<Permissions> = [];

    for (let i = 0; i < PERMISSIONS.length; i++) {
      let state = await atManager.checkAccessToken(tokenId, PERMISSIONS[i])
      console.log(TAG, `checkAccessToken success, ${PERMISSIONS[i]} + : ${JSON.stringify(state)}`);
      if (state !== abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
        permsPendingList.push(PERMISSIONS[i]);
      }
    }
    if (permsPendingList.length > 0) {
      console.info(TAG, 'grantPermission requestPermissionsFromUser :' + JSON.stringify(permsPendingList));
      let result = await atManager.requestPermissionsFromUser(context, permsPendingList);
      let grantStatus: Array<number> = result.authResults;
      for (let i = 0; i < grantStatus.length; i++) {
        console.info(TAG, `grantPermission requestPermissionsFromUser ${result.permissions[i]} + : ${grantStatus[i]}`);
        if (grantStatus[i] === 0) {
          // 用户授权，可以继续访问目标操作
        } else {
          // 用户拒绝授权，提示用户必须授权才能访问当前页面的功能
          console.log(TAG + 'grantPermission  fail ');
          return false;
        }
      }
      console.info(TAG, "data:" + JSON.stringify(result));
      console.info(TAG, "data permissions:" + result.permissions);
      console.info(TAG, "data authResults:" + result.authResults);
    }
    // 授权成功
    console.info(TAG, 'grantPermission success! ');
    return true;
  } catch (err) {
    console.log(TAG, `grantPermission fail: ${err.message}`,);
    return false;
  }
}