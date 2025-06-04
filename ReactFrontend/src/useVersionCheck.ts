import { useEffect, useRef } from 'react';

export default function useVersionCheck(intervalMs = 60000) {
  const lastVersion = useRef<string | null>(null);

  useEffect(() => {
    let timer: NodeJS.Timeout;
    const checkVersion = async () => {
      try {
        const res = await fetch('/version.txt', { cache: 'no-store' });
        if (res.ok) {
          const version = await res.text();
          if (lastVersion.current && lastVersion.current !== version) {
            window.location.reload(true);
          }
          lastVersion.current = version;
        }
      } catch {}
      timer = setTimeout(checkVersion, intervalMs);
    };
    checkVersion();
    return () => clearTimeout(timer);
  }, [intervalMs]);
}
