'use client';

import React, { createContext, useCallback, useContext, useEffect, useState } from 'react';
import { api } from './api';

interface CartContextType {
  itemsCount: number;
  refreshCart: () => Promise<void>;
}

const CartContext = createContext<CartContextType | undefined>(undefined);

export function CartProvider({ children }: { children: React.ReactNode }) {
  const [itemsCount, setItemsCount] = useState(0);

  const refreshCart = useCallback(async () => {
    try {
      const data = await api.get('/cart');
      setItemsCount(data.cart.items_count);
    } catch {
      setItemsCount(0);
    }
  }, []);

  useEffect(() => {
    refreshCart();
  }, [refreshCart]);

  return (
    <CartContext.Provider value={{ itemsCount, refreshCart }}>
      {children}
    </CartContext.Provider>
  );
}

export function useCart() {
  const ctx = useContext(CartContext);
  if (!ctx) throw new Error('useCart must be used within CartProvider');
  return ctx;
}
