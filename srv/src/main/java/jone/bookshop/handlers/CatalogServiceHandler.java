package jone.bookshop.handlers;

import java.util.Map;

import com.sap.cds.Result;
import com.sap.cds.ql.Insert;
import com.sap.cds.ql.Select;
import com.sap.cds.ql.cqn.AnalysisResult;
import com.sap.cds.ql.cqn.CqnAnalyzer;
import com.sap.cds.ql.cqn.CqnInsert;
import com.sap.cds.ql.cqn.CqnSelect;
import com.sap.cds.reflect.CdsModel;
import com.sap.cds.services.handler.EventHandler;
import com.sap.cds.services.handler.annotations.On;
import com.sap.cds.services.handler.annotations.After;
import com.sap.cds.services.handler.annotations.Before;
import com.sap.cds.services.handler.annotations.ServiceName;
import com.sap.cds.services.persistence.PersistenceService;
import com.sap.cds.services.ServiceException;
import com.sap.cds.services.ErrorStatuses;

import org.springframework.stereotype.Component;

import cds.gen.catalogservice.AddReviewContext;
import cds.gen.catalogservice.CatalogService_;
import cds.gen.catalogservice.Reviews;
import cds.gen.catalogservice.Reviews_;
import cds.gen.sun.bookshop.Books;
import cds.gen.catalogservice.Books_;
import com.sap.cds.services.messages.Messages;
import jone.bookshop.RatingCalculator;

@Component
@ServiceName(CatalogService_.CDS_NAME)
public class CatalogServiceHandler implements EventHandler {

    private final CqnAnalyzer analyzer;
    private final PersistenceService db;
    private final Messages messages;
    private final RatingCalculator ratingCalculator;

    CatalogServiceHandler(PersistenceService db,CdsModel model,Messages messages,RatingCalculator ratingCalculator){
        this.db = db;
        this.analyzer = CqnAnalyzer.create(model);        
        this.messages = messages;
        this.ratingCalculator = ratingCalculator;
    }
	/**
	 * Invokes some validations before creating a review.
	 *
	 * @param context {@link ReviewContext}
	 */
	@Before(entity = Books_.CDS_NAME)
	public void beforeAddReview(AddReviewContext context) {
		String user = context.getUserInfo().getName();
		String bookId = (String) analyzer.analyze(context.getCqn()).targetKeys().get(Books.ID);

		Result result = db.run(Select.from(CatalogService_.REVIEWS)
				.where(review -> review.book_ID().eq(bookId).and(review.createdBy().eq(user))));

		if (result.first().isPresent()) {
			throw new ServiceException(ErrorStatuses.METHOD_NOT_ALLOWED, "Review already added by you before")
					.messageTarget(Reviews_.class, r -> r.createdBy());
		}
	}

    /**
	 * Recalculates and sets the book rating after a new review for the given book.
	 *
	 * @param context {@link ReviewContext}
	 */
	@After(entity = Books_.CDS_NAME)
	public void afterAddReview(AddReviewContext context) {
		ratingCalculator.setBookRating(context.getResult().getBookId());
	}

    @On(event = AddReviewContext.CDS_NAME)
    public void addReview(AddReviewContext context){
        // System.out.println("Triggered the action");
        if(context.getRating()>5||context.getRating()<1){
            messages.error("Input rate:"+context.getRating()+" is invlid, please input rate from 1 to 5");
        }
        
       CqnSelect select =context.getCqn();

    //    AnalysisResult analysisResult = analyzer.analyze(select);
    //    Map<String, Object> tagetKeys = analyzer.analyze(select).targetKeys();
        String bookId =(String) analyzer.analyze(select).targetKeys().get(Books.ID);
        System.out.println(bookId);

        Reviews review = Reviews.create();   
        review.setBookId(bookId);     
        review.setTitle(context.getTitle());
        review.setRating(context.getRating());
        review.setText(context.getText());

        System.out.println(review);

   

        CqnInsert reviewInsert = Insert.into(Reviews_.CDS_NAME).entry(review);
        // Result savedReview = db.run(reviewInsert);

        Reviews newReview = db.run(reviewInsert).single(Reviews.class);

        context.setResult(newReview);
    }
}
