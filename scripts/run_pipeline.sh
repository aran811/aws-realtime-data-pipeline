# ---------------------------------------------
# Step 5: Wait for data to appear in DynamoDB
# ---------------------------------------------
echo "🗄️ Waiting for data to appear in DynamoDB table..."

MAX_RETRIES=12        # e.g. 12 retries
SLEEP_SECONDS=5      # wait 5s between retries
ATTEMPT=1

while [ $ATTEMPT -le $MAX_RETRIES ]; do
  echo "🔄 Scan attempt $ATTEMPT/$MAX_RETRIES..."

  ITEM_COUNT=$(aws dynamodb scan \
    --table-name "$DYNAMO_TABLE_NAME" \
    --select "COUNT" \
    --query "Count" \
    --output text)

  if [ "$ITEM_COUNT" -gt 0 ]; then
    echo "✅ Data detected in DynamoDB! ($ITEM_COUNT items)"
    echo "📊 Full table scan output:"
    aws dynamodb scan --table-name "$DYNAMO_TABLE_NAME"
    break
  fi

  echo "⏳ No data yet. Waiting ${SLEEP_SECONDS}s..."
  sleep $SLEEP_SECONDS
  ATTEMPT=$((ATTEMPT + 1))
done

if [ "$ATTEMPT" -gt "$MAX_RETRIES" ]; then
  echo "❌ Timed out waiting for DynamoDB data."
  exit 1
fi

