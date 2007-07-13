package ru.org.linux.site.boxes;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Date;

import ru.org.linux.site.NewsViewer;
import ru.org.linux.site.config.PropertiesConfig;
import ru.org.linux.site.config.SQLConfig;
import ru.org.linux.util.ProfileHashtable;
import ru.org.linux.util.UtilException;

public final class fullnews {
  public String getContent(Object config, ProfileHashtable profile) throws IOException, SQLException,  UtilException {
    Connection db = null;
    try {
      db = ((SQLConfig) config).getConnection("fullnews");
      StringBuffer buf = new StringBuffer();
      Statement st = db.createStatement();
      ResultSet rs = st.executeQuery("SELECT topics.stat1, topics.lastmod, topics.title as subj, postdate, nick, image, groups.title as gtitle, topics.id as msgid, sections.comment, groups.id as guid, topics.url, topics.linktext, sections.imagepost, linkup, postdate<(CURRENT_TIMESTAMP-expire) as expired, message FROM topics,groups,users,sections,msgbase WHERE sections.id=groups.section AND topics.id=msgbase.id AND topics.moderate AND topics.userid=users.id AND topics.groupid=groups.id AND section=1 AND NOT deleted AND commitdate>(CURRENT_TIMESTAMP-'12 month'::interval) ORDER BY commitdate DESC LIMIT 20");
      NewsViewer nw = new NewsViewer(((PropertiesConfig) config).getProperties(), profile, rs, false, false);
      buf.append(nw.showAll());
      rs.close();
      return buf.toString();
    } finally {
      if (db != null) {
        ((SQLConfig) config).SQLclose();
      }
    }
  }

  public String getInfo() {
    return "�����";
  }

  public String getVariantID(ProfileHashtable prof) throws UtilException {
    return "SearchMode=" + prof.getBoolean("SearchMode") + "&topics=" + prof.getInt("topics")+"&messages=" + prof.getInt("messages") + "&style=" + prof.getString("style");
  }

  public Date getExpire() {
    return new Date(new Date().getTime() + 60*1000);
  }
}
