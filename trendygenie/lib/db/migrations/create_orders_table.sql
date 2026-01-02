-- Create orders table with proper relationships
CREATE TABLE IF NOT EXISTS "public"."orders" (
  "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  "customer_id" UUID NOT NULL REFERENCES auth.users(id),
  "business_id" UUID NOT NULL REFERENCES companies(id),
  "service_id" UUID NOT NULL REFERENCES services(id),
  "status" TEXT NOT NULL DEFAULT 'pending',
  "order_date" TIMESTAMP WITH TIME ZONE DEFAULT now(),
  "total_amount" DECIMAL(10, 2) NOT NULL,
  "payment_status" TEXT DEFAULT 'pending',
  "rejection_reason" TEXT,
  "created_at" TIMESTAMP WITH TIME ZONE DEFAULT now(),
  "updated_at" TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Add indexes for better performance
CREATE INDEX IF NOT EXISTS idx_orders_customer_id ON orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_orders_business_id ON orders(business_id);
CREATE INDEX IF NOT EXISTS idx_orders_service_id ON orders(service_id);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);

-- Add RLS (Row Level Security) policies
ALTER TABLE "public"."orders" ENABLE ROW LEVEL SECURITY;

-- Allow read access for authenticated users
CREATE POLICY "Allow users to view their own orders" 
ON "public"."orders"
FOR SELECT
USING (auth.uid() = customer_id);

-- Allow business owners to view orders for their businesses
CREATE POLICY "Allow business owners to view business orders" 
ON "public"."orders"
FOR SELECT
USING (EXISTS (
  SELECT 1 FROM companies 
  WHERE companies.id = orders.business_id AND companies.owner_id = auth.uid()
));

-- Allow users to create orders
CREATE POLICY "Allow users to create orders" 
ON "public"."orders"
FOR INSERT
WITH CHECK (auth.uid() = customer_id);

-- Allow business owners to update orders for their businesses
CREATE POLICY "Allow business owners to update orders" 
ON "public"."orders"
FOR UPDATE
USING (EXISTS (
  SELECT 1 FROM companies 
  WHERE companies.id = orders.business_id AND companies.owner_id = auth.uid()
)); 