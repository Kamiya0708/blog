require 'rails_helper'

describe '記事管理機能', type: :system do
  let(:login_admin) {FactoryBot.create(:user)}

  before do
    # 管理者ログイン
    visit login_path
    fill_in 'ユーザ名', with: login_admin.name
    fill_in 'パスワード', with: login_admin.password
    click_button 'ログイン'

    # 記事作成
    click_link '記事作成'
    fill_in 'タイトル', with: 'タイトルテスト'
    find('.fr-element.fr-view').send_keys('内容テスト')
    click_button '登録'
    click_link '記事一覧'
  end

  context '管理者機能テスト' do
    it 'ログイン' do
      visit login_path
      fill_in 'ユーザ名', with: login_admin.name
      fill_in 'パスワード', with: login_admin.password
      click_button 'ログイン'

      expect(page).to have_content 'ログインしました'
    end

    it 'ログアウト' do
      click_link 'ログアウト'

      expect(page).to have_content 'ログアウトしました'
    end
  end

  context '記事機能テスト' do
    it '新規作成' do
      click_link '記事作成'
      fill_in 'タイトル', with: '新規作成'
      find('.fr-element.fr-view').send_keys('内容入力テスト')
      click_button '登録'

      expect(page).to have_content '記事を作成しました'
      expect(page).to have_selector 'h1', text: '新規作成'
    end

    it '編集' do
      click_link '編集'
      fill_in 'タイトル', with: 'タイトル編集'
      find('.fr-element.fr-view').send_keys('内容編集')
      click_button '更新'

      expect(page).to have_selector 'h1', text: 'タイトル編集'
      expect(page).to have_content '内容編集'
    end

    it '削除' do
      click_link '削除'
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_content '記事を削除しました'
      expect(page).to have_no_selector 'h1', text: 'タイトルテスト'
    end
  end
end