#!/bin/bash

#パスワードをテキストファイルに保存する
echo 'パスワードマネージャーへようこそ！'
echo 'サービス名を入力してください：'
read -r service

#同じサービスであった場合、再入力してもらう
while grep -q "$service" step1/password_step1.txt; do
    echo "既に登録されたサービスです。再入力してください"
    read -r service
done

echo 'ユーザー名を入力してください：'
read -r user
echo 'パスワードを入力してください：'
read -r password
echo 'Thank you!'
#テキストファイルに入力された情報を保存する
echo "$service:$user:$password" >> step1/password_step1.txt